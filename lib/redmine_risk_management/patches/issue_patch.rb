module RedmineRiskManagement
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          belongs_to :risk, optional: true
          has_many :risk_issues, dependent: :destroy
          has_many :risks, through: :risk_issues

          safe_attributes 'risk_id', 'risk_ids'
        end
      end
    end
  end
end

unless Issue.included_modules.include?(RedmineRiskManagement::Patches::IssuePatch)
  Issue.send(:include, RedmineRiskManagement::Patches::IssuePatch)
end
