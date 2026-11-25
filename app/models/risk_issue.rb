class RiskIssue < ApplicationRecord
  belongs_to :risk
  belongs_to :issue

  validates :risk_id, uniqueness: { scope: :issue_id }
end
