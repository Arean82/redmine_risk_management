class RiskIssuesController < ApplicationController
  before_action :find_risk
  before_action :authorize_manage_relations

  def create
    raw_id = params[:issue_id].to_s.strip
    issue_id = raw_id.start_with?('#') ? raw_id[1..-1] : raw_id
    @issue = Issue.visible.find_by(id: issue_id)

    if @issue && !@risk.issues.include?(@issue)
      @risk.init_journal(User.current, "Linked issue ##{@issue.id}")
      @risk.issues << @issue
    end

    respond_to do |format|
      format.html { redirect_to project_risk_path(@risk.project, @risk) }
      format.js
    end
  end

  def destroy
    @issue = @risk.issues.find_by(id: params[:issue_id])
    if @issue
      @risk.init_journal(User.current, "Unlinked issue ##{@issue.id}")
      @risk.issues.delete(@issue)
    end

    respond_to do |format|
      format.html { redirect_to project_risk_path(@risk.project, @risk) }
      format.js
    end
  end

  private

  def find_risk
    @risk = Risk.find(params[:risk_id])
    @project = @risk.project
  end

  def authorize_manage_relations
    deny_access unless User.current.allowed_to?(:edit_risks, @project)
  end
end
