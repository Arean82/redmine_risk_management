module RedmineRiskManagement
  module Patches
    module QueriesHelperPatch
      def column_content(column, item)
        if column.name == :risks && item.is_a?(Issue)
          risks = item.risks
          if risks.any?
            content_tag(:div) do
              risks.map do |r|
                badge_color = r.risk_status&.color_name || '#666666'
                badge_color = '#' + badge_color unless badge_color.start_with?('#')
                content_tag(:span, class: 'badge', style: "background: #{badge_color}; color: #fff; padding: 2px 6px; border-radius: 3px; font-size: 10px; margin-right: 4px; display: inline-block;") do
                  path = Rails.application.routes.url_helpers.risk_path(r)
                  link_to("##{r.id} (#{r.criticality})", path, style: 'color: #fff; text-decoration: none;')
                end
              end.join(' ').html_safe
            end
          else
            '-'
          end
        else
          super
        end
      end
    end
  end
end

unless QueriesHelper.ancestors.include?(RedmineRiskManagement::Patches::QueriesHelperPatch)
  QueriesHelper.prepend(RedmineRiskManagement::Patches::QueriesHelperPatch)
end
