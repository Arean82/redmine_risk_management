class AddDueDateAndStrategyToRisks < ActiveRecord::Migration[7.0]
  def change
    add_column :risks, :due_date, :date
    add_column :risks, :strategy, :string, default: 'mitigate'

    add_index :risks, :due_date
    add_index :risks, :strategy
  end
end
