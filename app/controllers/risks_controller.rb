class RisksController < ApplicationController
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper

  before_action :find_project_by_project_id, only: [:index, :new, :create]
  before_action :find_risk, only: [:show, :edit, :update, :destroy]
  before_action :find_risks, only: [:bulk_edit, :bulk_update, :bulk_destroy]
  before_action :authorize, except: [:index, :bulk_edit, :bulk_update, :bulk_destroy]
  before_action :authorize_global, only: [:bulk_edit, :bulk_update, :bulk_destroy]

  def index
    use_session = !request.format.csv?
    retrieve_query(RiskQuery, use_session)

    if @query.valid?
      @limit = per_page_option
      @risk_count = @query.risk_count
      @risk_pages = Paginator.new @risk_count, @limit, params['page']
      @offset ||= @risk_pages.offset
      @risks = @query.risks(order: sort_clause, offset: @offset, limit: @limit)

      respond_to do |format|
        format.html
        format.api
        format.csv  { send_data(query_to_csv(@risks, @query, params[:csv]), type: 'text/csv; header=present', filename: 'risks.csv') }
      end
    else
      respond_to do |format|
        format.html { render action: 'index', layout: !request.xhr? }
        format.any(:atom, :csv, :pdf) { head 422 }
        format.api { render_validation_errors(@query) }
      end
    end
  end

  def show
    @issues = @risk.issues
    @journals = @risk.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC").to_a
    @journals.each_with_index { |j, i| j.indice = i + 1 }
    @journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @risk.project)
    Journal.preload_journals_details_reflected_objects(@journals)
    @journals.reverse! if User.current.wants_comments_in_reverse_order?
  end

  def new
    @risk = Risk.new
    @risk.project = @project
    @risk_statuses = RiskStatus.ordered
    @categories = @project.risk_categories.ordered
  end

  def create
    @risk = Risk.new
    @risk.project = @project
    @risk.user = User.current
    @risk.safe_attributes = params[:risk]

    if @risk.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_risks_path(@project)
    else
      @risk_statuses = RiskStatus.ordered
      @categories = @project.risk_categories.ordered
      render action: 'new'
    end
  end

  def edit
    @risk_statuses = RiskStatus.ordered
    @categories = @risk.project.risk_categories.ordered
  end

  def update
    @risk.init_journal(User.current, params[:risk][:notes]) if params[:risk][:notes].present?
    @risk.safe_attributes = params[:risk]

    if @risk.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_risk_path(@risk.project, @risk)
    else
      @risk_statuses = RiskStatus.ordered
      @categories = @risk.project.risk_categories.ordered
      render action: 'edit'
    end
  end

  def destroy
    project = @risk.project
    if @risk.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_delete)
    end
    redirect_to project_risks_path(project)
  end

  def bulk_edit
    @statuses = RiskStatus.ordered
    @categories = @project ? @project.risk_categories.ordered : RiskCategory.ordered
    @assignees = @project ? @project.assignable_users : []
  end

  def bulk_update
    attributes = parse_params_for_bulk_risk_attributes(params[:risk])
    unsaved_risks = []

    @risks.each do |risk|
      risk.init_journal(User.current, params[:notes]) if params[:notes].present?
      risk.safe_attributes = attributes
      unless risk.save
        unsaved_risks << risk
      end
    end

    if unsaved_risks.empty?
      flash[:notice] = l(:notice_successful_update)
    else
      flash[:error] = unsaved_risks.map { |r| "#{r.title}: #{r.errors.full_messages.join(', ')}" }.join('<br/>').html_safe
    end

    redirect_back_or_default project_risks_path(@project || @risks.first.project)
  end

  def bulk_destroy
    @risks.each(&:destroy)
    flash[:notice] = l(:notice_successful_delete)
    redirect_back_or_default project_risks_path(@project || @risks.first.project)
  end

  private

  def find_risk
    @risk = Risk.find(params[:id])
    @project = @risk.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_risks
    @risks = Risk.where(id: params[:id] || params[:ids])
    raise ActiveRecord::RecordNotFound if @risks.empty?

    @projects = @risks.map(&:project).compact.uniq
    @project = @projects.first if @projects.size == 1
  end

  def parse_params_for_bulk_risk_attributes(params)
    attributes = (params || {}).to_unsafe_hash if params.respond_to?(:to_unsafe_hash)
    attributes ||= params || {}
    attributes.delete_if { |k, v| v.blank? }
    attributes
  end
end
