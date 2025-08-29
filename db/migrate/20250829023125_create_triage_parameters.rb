class CreateTriageParameters < ActiveRecord::Migration[6.1]
  def change
    create_table :triage_parameters do |t|
      t.string :name
      t.string :code_name
      t.string :data_type # 'integer', 'string', 'boolean', 'float'
      t.string :category
      t.text :description
      t.integer :position
      t.boolean :active, default: true
      t.timestamps
    end
  end
end