class RiskContextMenusController < ApplicationController
  before_action :find_risks

  def index
    @risk = @risks.first if @risks.size == 1
    @project = @risks.first.project if @risks.present?

    @can = {
      edit: @risks.all? { |r| r.editable?(User.current) },
      delete: @risks.all? { |r| r.deletable?(User.current) }
    }

    @statuses = RiskStatus.ordered
    @categories = @project ? @project.risk_categories.ordered : RiskCategory.ordered
    @assignees = @project ? @project.assignable_users : []

    @safe_attributes = ['risk_status_id', 'category_id', 'assigned_to_id', 'probability', 'impact']

    render layout: false
  end

  private

  def find_risks
    @risks = Risk.where(id: params[:ids])
    raise ActiveRecord::RecordNotFound if @risks.empty?

    # Check permission on all projects involved
    projects = @risks.map(&:project).uniq
    projects.each do |project|
      unless User.current.allowed_to?(:view_risks, project)
        deny_access
        return
      end
    end
  end
end
