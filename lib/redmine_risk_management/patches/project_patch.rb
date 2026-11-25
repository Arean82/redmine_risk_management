module RedmineRiskManagement
  module Patches
    module ProjectPatch
      def self.included(base)
        base.class_eval do
          has_many :risks, dependent: :destroy
          has_many :risk_categories, dependent: :destroy
        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineRiskManagement::Patches::ProjectPatch)
  Project.send(:include, RedmineRiskManagement::Patches::ProjectPatch)
end
