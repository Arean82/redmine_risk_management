class EnhanceRiskManagementSchema < ActiveRecord::Migration[7.0]
  def up
    # 1. Join table for Many-to-Many issue-risk relationships
    create_table :risk_issues do |t|
      t.integer :risk_id,  null: false
      t.integer :issue_id, null: false
    end
    add_index :risk_issues, [:risk_id, :issue_id], unique: true, name: :risk_issues_ids
    add_index :risk_issues, :issue_id

    # Migrate any existing one-to-many issues into risk_issues
    execute <<~SQL
      INSERT INTO risk_issues (risk_id, issue_id)
      SELECT risk_id, id FROM issues WHERE risk_id IS NOT NULL
      ON CONFLICT DO NOTHING
    SQL

    # 2. Risk Categories table (project-level or global)
    create_table :risk_categories do |t|
      t.integer :project_id
      t.string  :name, null: false
      t.integer :position
      t.timestamps
    end
    add_index :risk_categories, :project_id

    # 3. Add category_id, assigned_to_id, lessons, and treatments to risks
    add_column :risks, :category_id, :integer
    add_column :risks, :assigned_to_id, :integer
    add_column :risks, :treatments, :text
    add_column :risks, :lessons, :text
    add_column :risks, :closed_on, :datetime

    add_index :risks, :category_id
    add_index :risks, :assigned_to_id
  end

  def down
    remove_index :risks, :assigned_to_id if index_exists?(:risks, :assigned_to_id)
    remove_index :risks, :category_id if index_exists?(:risks, :category_id)
    remove_column :risks, :closed_on
    remove_column :risks, :lessons
    remove_column :risks, :treatments
    remove_column :risks, :assigned_to_id
    remove_column :risks, :category_id

    drop_table :risk_categories if table_exists?(:risk_categories)
    drop_table :risk_issues if table_exists?(:risk_issues)
  end
end
