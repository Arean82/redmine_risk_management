class RiskCategory < ApplicationRecord
  include Redmine::SafeAttributes

  belongs_to :project, optional: true
  has_many :risks, foreign_key: 'category_id', dependent: :nullify

  acts_as_positioned scope: :project_id

  validates :name, presence: true, length: { maximum: 60 }
  validates :name, uniqueness: { scope: :project_id, case_sensitive: false }

  safe_attributes 'name', 'position', 'project_id'

  scope :ordered, -> { order(:position, :name) }
  scope :for_project, ->(prj) { where(project_id: [nil, prj&.id]).order(:position, :name) }

  def to_s
    name
  end
end
