module RedmineRiskManagement
  module Hooks
    class ViewsProjectsHook < Redmine::Hook::ViewListener
      render_on :view_projects_show_right, partial: 'hooks/view_projects_show_sidebar'
    end
  end
end
