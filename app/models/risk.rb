class Risk < ApplicationRecord
  include Redmine::SafeAttributes
  include Redmine::Acts::ActivityProvider
  include Redmine::Acts::Event

  PER_PAGE   = 30
  RATIONALES = ['Monitor', 'Plan Mitigation', 'Mitigate'].freeze
  STRATEGIES = ['mitigate', 'accept', 'transfer', 'eliminate'].freeze

  belongs_to :project
  belongs_to :risk_status
  belongs_to :user
  belongs_to :assigned_to, class_name: 'Principal', optional: true
  belongs_to :category, class_name: 'RiskCategory', optional: true

  # Many-to-many relationship with issues
  has_many :risk_issues, dependent: :destroy
  has_many :issues, through: :risk_issues

  # Redmine Journals for change and notes history
  has_many :journals, as: :journalized, dependent: :destroy, inverse_of: :journalized

  acts_as_event title: proc { |o| "#{I18n.t(:label_risk)} ##{o.id}: #{o.title}" },
                url: proc { |o| { controller: 'risks', action: 'show', id: o.id } },
                description: :description,
                type: 'risk'

  acts_as_activity_provider type: 'risks',
                            timestamp: "#{table_name}.updated_at",
                            author_key: :user_id,
                            permission: :view_risks,
                            scope: joins(:project)

  validates :title, :description, presence: true
  validates :criticality, numericality: true, allow_nil: true
  validates :probability, :impact, numericality: { greater_than: 0, less_than: 5 }
  validates :rationale, inclusion: { in: RATIONALES }, allow_nil: true
  validates :strategy, inclusion: { in: STRATEGIES }, allow_nil: true
  validates :estimated_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_save :set_criticality_rationale, :update_closed_status, :calculate_financial_emv, :track_velocity
  after_save :create_journal, :send_notification

  attr_accessor :current_journal
  attr_accessor :notes

  safe_attributes 'title', 'description', 'probability', 'impact', 'risk_status_id',
                  'category_id', 'assigned_to_id', 'treatments', 'lessons', 'issue_ids', 'notes',
                  'due_date', 'strategy', 'estimated_cost'

  scope :open_risks, -> { joins(:risk_status).where(risk_statuses: { status_type: 'open' }) }
  scope :closed_risks, -> { joins(:risk_status).where(risk_statuses: { status_type: 'closed' }) }

  def closed?
    risk_status&.status_type == 'closed'
  end

  def velocity_trend
    return 'neutral' if previous_criticality.nil? || criticality == previous_criticality
    criticality > previous_criticality ? 'escalated' : 'mitigated'
  end

  def init_journal(usr, nts = '')
    @current_journal ||= journals.build(user: usr, notes: nts)
  end

  def journalized_attribute_names
    Risk.column_names - %w(id created_at updated_at closed_on previous_criticality)
  end

  def custom_field_values
    []
  end

  def custom_values
    []
  end

  def valid_watcher?(usr)
    usr.active? && usr.allowed_to?(:view_risks, project)
  end

  def notified_watchers
    []
  end

  def notified_users
    recipients = [user, assigned_to].compact.select(&:active?)
    recipients.select { |u| u.allowed_to?(:view_risks, project) }
  end

  def notified_mentions
    []
  end

  def set_watcher(usr, watching = true)
  end

  def visible?(usr = nil)
    (usr || User.current).allowed_to?(:view_risks, project)
  end

  def editable?(usr = nil)
    (usr || User.current).allowed_to?(:edit_risks, project)
  end

  def deletable?(usr = nil)
    (usr || User.current).allowed_to?(:delete_risks, project)
  end

  private

  def set_criticality_rationale
    if probability.present? && impact.present?
      self.criticality = probability * impact
      self.rationale =
        case criticality
        when 1..4
          'Monitor'
        when 5..9
          'Plan Mitigation'
        when 10..16
          'Mitigate'
        end
    end
  end

  def calculate_financial_emv
    prob_ratio = case probability
                 when 1 then 0.10
                 when 2 then 0.25
                 when 3 then 0.50
                 when 4 then 0.90
                 else 0.0
                 end
    cost = estimated_cost.to_f
    self.emv = (cost * prob_ratio).round(2)
  end

  def track_velocity
    if criticality_changed? && !new_record?
      self.previous_criticality = criticality_was
    end
  end

  def update_closed_status
    if risk_status_id_changed?
      if closed?
        self.closed_on ||= Time.current
      else
        self.closed_on = nil
      end
    end
  end

  def create_journal
    if @current_journal
      @current_journal.save
    elsif notes.present?
      journals.create(user: User.current, notes: notes)
    end
  end

  def send_notification
    # Queue risk mailer notification asynchronously if configured
    RiskMailer.deliver_risk_notification(self) rescue nil
  end
end
