class RiskCategoriesController < ApplicationController
  before_action :find_optional_project
  before_action :find_category, only: [:edit, :update, :destroy]
  before_action :authorize_category_management

  def new
    @category = @project ? @project.risk_categories.build : RiskCategory.new
  end

  def create
    @category = @project ? @project.risk_categories.build : RiskCategory.new
    @category.safe_attributes = params[:risk_category]
    if @category.save
      flash[:notice] = l(:notice_successful_create)
      redirect_back_or_default(settings_plugin_path(id: 'redmine_risk_management', tab: 'categories'))
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    @category.safe_attributes = params[:risk_category]
    if @category.save
      flash[:notice] = l(:notice_successful_update)
      redirect_back_or_default(settings_plugin_path(id: 'redmine_risk_management', tab: 'categories'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_back_or_default(settings_plugin_path(id: 'redmine_risk_management', tab: 'categories'))
  end

  private

  def find_optional_project
    @project = Project.find_by(id: params[:project_id]) if params[:project_id].present?
  end

  def find_category
    @category = RiskCategory.find(params[:id])
    @project ||= @category.project
  end

  def authorize_category_management
    if User.current.admin?
      true
    elsif @project
      if @project.module_enabled?(:risks)
        authorize
      else
        deny_access
      end
    else
      deny_access
    end
  end
end
