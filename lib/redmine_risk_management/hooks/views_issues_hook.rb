module RedmineRiskManagement
  module Hooks

    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom, partial: 'issues/risk_form'
      render_on :view_issues_show_details_bottom, partial: 'issues/risk'

      def view_layouts_base_html_head(context = {})
        stylesheet_link_tag('risks', plugin: 'redmine_risk_management')
      end
    end

  end
end
