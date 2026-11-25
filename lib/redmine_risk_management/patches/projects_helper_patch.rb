module RedmineRiskManagement
  module Patches
    module ProjectsHelperPatch
      def project_settings_tabs
        tabs = super
        tab = {
          name: 'risk_categories',
          action: :manage_risk_categories,
          partial: 'projects/settings/risk_categories',
          label: :label_risk_category_plural
        }
        if User.current.allowed_to?(tab[:action], @project) && @project.module_enabled?(:risks)
          tabs << tab
        end
        tabs
      end
    end
  end
end

unless ProjectsHelper.ancestors.include?(RedmineRiskManagement::Patches::ProjectsHelperPatch)
  ProjectsHelper.prepend(RedmineRiskManagement::Patches::ProjectsHelperPatch)
end
