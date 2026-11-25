class AddFinancialExposureAndVelocityToRisks < ActiveRecord::Migration[7.0]
  def change
    add_column :risks, :estimated_cost, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :risks, :emv, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :risks, :previous_criticality, :integer

    add_index :risks, :estimated_cost
    add_index :risks, :emv
  end
end
