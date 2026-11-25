require 'redmine'

Redmine::Plugin.register :redmine_risk_management do
  name 'Redmine Risk Management plugin'
  author 'Arean Narrayan'
  description 'Enterprise ISO 31000 Risk Management plugin for Redmine'
  version '0.0.6'
  url 'https://github.com/Arean82/redmine_risk_management/'
  author_url 'https://github.com/Arean82'

  settings default: {
    status: ['Identified', 'Monitored', 'Occurred', 'Dismissed']
  }, partial: 'settings/risks'

  project_module :risks do
    permission :view_risks, { risks: [:index, :show], risk_dashboards: [:show] }, read: true
    permission :add_risks, { risks: [:new, :create, :preview] }
    permission :edit_risks, { risks: [:edit, :update, :bulk_edit, :bulk_update, :preview], risk_issues: [:create, :destroy] }
    permission :delete_risks, { risks: [:destroy, :bulk_destroy] }, require: :member
    permission :manage_risk_categories, { risk_categories: [:new, :create, :edit, :update, :destroy] }, require: :member
  end

  activity_provider :risks, class_name: ['Risk'], default: true

  menu :project_menu, :risks, { controller: :risks, action: :index },
       caption: :label_risk_plural, before: :settings, param: :project_id
end

require_relative 'lib/redmine_risk_management/hooks/views_issues_hook'

Rails.configuration.to_prepare do
  Issue.include(RedmineRiskManagement::Patches::IssuePatch) unless Issue.included_modules.include?(RedmineRiskManagement::Patches::IssuePatch)
  Project.include(RedmineRiskManagement::Patches::ProjectPatch) unless Project.included_modules.include?(RedmineRiskManagement::Patches::ProjectPatch)
  ProjectsHelper.prepend(RedmineRiskManagement::Patches::ProjectsHelperPatch) unless ProjectsHelper.ancestors.include?(RedmineRiskManagement::Patches::ProjectsHelperPatch)
  CustomFieldsHelper::CUSTOM_FIELDS_TABS << { name: 'RiskCustomField', partial: 'custom_fields/index', label: :label_risk_plural } unless CustomFieldsHelper::CUSTOM_FIELDS_TABS.any? { |t| t[:name] == 'RiskCustomField' }
end
