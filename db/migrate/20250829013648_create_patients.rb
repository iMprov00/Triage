class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.date :birth_date
      t.datetime :admission_date
      
      t.timestamps
    end
  end
end