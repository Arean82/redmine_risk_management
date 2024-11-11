#require 'redmine_risk_management'
require 'redmine'

Redmine::Plugin.register :redmine_risk_management do
  name 'Redmine Risk Management plugin'
  author 'Arean Narrayan'
  description 'Risk management plugin for Redmine'
  version '0.5'
  url 'https://github.com/Arean82/redmine_risk_management/'
  

  settings default: {
    status: ['Identified', 'Monitored', 'Occurred', 'Dismissed']
  }, partial: 'settings/risks'

  project_module :risks do
    permission :view_risks, { risks: [:index, :show] }, { public: true }
    permission :add_risks, { risks: [:new, :create] }, { public: true }
    permission :edit_risks, { risks: [:edit, :update] }, { public: true }
    permission :delete_risks, { risks: :destroy }, { public: true }
  end

  menu :project_menu, :risks, { controller: :risks, action: :index },
       caption: :label_risk_plural, before: :settings, param: :project_id
end
