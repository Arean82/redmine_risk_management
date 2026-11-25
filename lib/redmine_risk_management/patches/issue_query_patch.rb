module RedmineRiskManagement
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.class_eval do
          unless available_columns.any? { |c| c.name == :risks }
            available_columns << QueryColumn.new(
              :risks,
              caption: :label_risk_plural,
              default_order: 'desc'
            )
          end
        end
        base.prepend(InstanceMethods) unless base.ancestors.include?(InstanceMethods)
      end

      module InstanceMethods
        def initialize_available_filters
          super
          add_available_filter(
            'has_risk',
            type: :list,
            values: [[l(:general_text_Yes), '1'], [l(:general_text_No), '0']],
            label: :label_risk_plural
          )
        end

        def sql_for_has_risk_field(field, operator, value)
          join_table = 'risk_issues'
          has_any = (value.first == '1')
          if (operator == '=' && has_any) || (operator == '!' && !has_any)
            "#{Issue.table_name}.id IN (SELECT DISTINCT issue_id FROM #{join_table})"
          else
            "#{Issue.table_name}.id NOT IN (SELECT DISTINCT issue_id FROM #{join_table})"
          end
        end
      end
    end
  end
end

unless IssueQuery.included_modules.include?(RedmineRiskManagement::Patches::IssueQueryPatch)
  IssueQuery.send(:include, RedmineRiskManagement::Patches::IssueQueryPatch)
end
