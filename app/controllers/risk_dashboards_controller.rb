class RiskDashboardsController < ApplicationController
  menu_item :risks

  before_action :find_project_by_project_id
  before_action :authorize

  def show
    scope = @project.risks
    @open_risks = scope.open_risks
    @total_count = scope.count
    @open_count = @open_risks.count
    @closed_count = scope.closed_risks.count

    # Criticality matrix distribution: [probability, impact] => count
    @matrix = @open_risks.group(:probability, :impact).count

    # Distribution by rationale
    @rationale_counts = @open_risks.group(:rationale).count

    # Top critical open risks
    @top_risks = @open_risks.order(criticality: :desc, id: :desc).limit(5)

    # Category breakdown
    @category_counts = @open_risks.joins(:category).group('risk_categories.name').count
    uncategorized = @open_risks.where(category_id: nil).count
    @category_counts[l(:label_none)] = uncategorized if uncategorized > 0

    # Status distribution
    @status_counts = scope.joins(:risk_status).group('risk_statuses.name').count
  end
end
