class RiskQuery < Query
  self.queried_class = Risk
  self.view_permission = :view_risks

  self.available_columns = [
    QueryColumn.new(:id, sortable: "#{Risk.table_name}.id", default_order: 'desc', caption: '#'),
    QueryColumn.new(:project, groupable: "#{Risk.table_name}.project_id", sortable: "#{Project.table_name}.id"),
    QueryColumn.new(:title, sortable: "#{Risk.table_name}.title", caption: :label_risk_title),
    QueryColumn.new(:risk_status, sortable: "#{RiskStatus.table_name}.position", groupable: true, caption: :field_status),
    QueryColumn.new(:category, sortable: "#{RiskCategory.table_name}.name", groupable: true, caption: :field_category),
    QueryColumn.new(:probability, sortable: "#{Risk.table_name}.probability", groupable: true, default_order: 'desc', caption: :field_probability),
    QueryColumn.new(:impact, sortable: "#{Risk.table_name}.impact", groupable: true, default_order: 'desc', caption: :field_impact),
    QueryColumn.new(:criticality, sortable: "#{Risk.table_name}.criticality", groupable: true, default_order: 'desc', caption: :field_criticality),
    QueryColumn.new(:rationale, sortable: "#{Risk.table_name}.rationale", groupable: true, caption: :field_rationale),
    QueryColumn.new(:strategy, sortable: "#{Risk.table_name}.strategy", groupable: true, caption: :field_strategy),
    QueryColumn.new(:estimated_cost, sortable: "#{Risk.table_name}.estimated_cost", default_order: 'desc', caption: 'Estimated Cost'),
    QueryColumn.new(:emv, sortable: "#{Risk.table_name}.emv", default_order: 'desc', caption: 'EMV (Exposure)'),
    QueryColumn.new(:due_date, sortable: "#{Risk.table_name}.due_date", default_order: 'asc', caption: :field_due_date),
    QueryColumn.new(:user, sortable: lambda { User.fields_for_order_statement('users') }, groupable: true, caption: :field_author),
    QueryColumn.new(:assigned_to, sortable: lambda { User.fields_for_order_statement }, groupable: true, caption: :field_assigned_to),
    QueryColumn.new(:created_at, sortable: "#{Risk.table_name}.created_at", default_order: 'desc', caption: :field_created_on),
    QueryColumn.new(:updated_at, sortable: "#{Risk.table_name}.updated_at", default_order: 'desc', caption: :field_updated_on),
    QueryColumn.new(:description, inline: false, caption: :field_description),
    QueryColumn.new(:treatments, inline: false, caption: :field_treatments),
    QueryColumn.new(:lessons, inline: false, caption: :field_lessons)
  ]

  def initialize(attributes = nil, *args)
    super attributes
    self.filters ||= { 'status_id' => { operator: 'o', values: [''] } }
  end

  def initialize_available_filters
    add_available_filter 'title', type: :text, label: :field_title

    # Status filter with open/closed presets
    status_values = RiskStatus.ordered.map { |s| [s.name, s.id.to_s] }
    add_available_filter 'status_id',
                         type: :list_status,
                         values: status_values,
                         label: :field_status

    if project.nil?
      add_available_filter 'project_id',
                           type: :list,
                           values: lambda { project_values }
    end

    add_available_filter 'category_id',
                         type: :list_optional,
                         values: lambda { category_values },
                         label: :field_category

    add_available_filter 'probability',
                         type: :list,
                         values: (1..4).map { |i| [i.to_s, i.to_s] },
                         label: :field_probability

    add_available_filter 'impact',
                         type: :list,
                         values: (1..4).map { |i| [i.to_s, i.to_s] },
                         label: :field_impact

    add_available_filter 'criticality',
                         type: :integer,
                         label: :field_criticality

    add_available_filter 'rationale',
                         type: :list,
                         values: Risk::RATIONALES.map { |r| [r, r] },
                         label: :field_rationale

    add_available_filter 'strategy',
                         type: :list,
                         values: Risk::STRATEGIES.map { |s| [s.humanize, s] },
                         label: :field_strategy

    add_available_filter 'due_date', type: :date, label: :field_due_date

    add_available_filter 'user_id',
                         type: :list,
                         values: lambda { author_values },
                         label: :field_author

    add_available_filter 'assigned_to_id',
                         type: :list_optional,
                         values: lambda { assigned_to_values },
                         label: :field_assigned_to

    add_available_filter 'created_at', type: :date_past, label: :field_created_on
    add_available_filter 'updated_at', type: :date_past, label: :field_updated_on
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
    @available_columns
  end

  def default_columns_names
    @default_columns_names ||= [:id, :title, :risk_status, :category, :probability, :impact, :criticality, :rationale, :assigned_to, :updated_at]
  end

  def default_sort_criteria
    [['id', 'desc']]
  end

  def category_values
    if project
      project.risk_categories.ordered.map { |c| [c.name, c.id.to_s] }
    else
      RiskCategory.ordered.map { |c| [c.name, c.id.to_s] }
    end
  end

  def base_scope
    Risk.joins(:project, :risk_status)
        .left_outer_joins(:category, :assigned_to, :user)
        .where(statement)
  end

  def risks(options = {})
    order_option = [group_by_sort_order, (options[:order] || sort_clause)].flatten.reject(&:blank?)

    scope = base_scope.order(order_option)
    if options[:include]
      scope = scope.includes(options[:include])
    else
      scope = scope.includes(:project, :risk_status, :category, :assigned_to, :user, :issues)
    end

    if options[:limit]
      scope = scope.limit(options[:limit])
    end
    if options[:offset]
      scope = scope.offset(options[:offset])
    end

    scope
  end

  def risk_count
    base_scope.count
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  # Custom sql statement for open / closed filter handling
  def sql_for_status_id_field(field, operator, value)
    status_table = RiskStatus.table_name
    case operator
    when 'o'
      "(#{status_table}.status_type = 'open')"
    when 'c'
      "(#{status_table}.status_type = 'closed')"
    when '*'
      '1=1'
    when '=', '!'
      compare = operator == '=' ? 'IN' : 'NOT IN'
      val_ids = value.map(&:to_i).join(',')
      val_ids.present? ? "(#{Risk.table_name}.risk_status_id #{compare} (#{val_ids}))" : '1=1'
    else
      '1=1'
    end
  end
end
