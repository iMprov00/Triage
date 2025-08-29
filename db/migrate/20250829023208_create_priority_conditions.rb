class CreatePriorityConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :priority_conditions do |t|
      t.integer :priority_level
      t.string :parameter_code
      t.string :operator # '==', '!=', '>', '<', '>=', '<=', 'contains', 'starts_with'
      t.string :value
      t.string :logical_operator # 'and', 'or'
      t.integer :position
      t.boolean :active, default: true
      t.timestamps
    end
  end
end