class CreateAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :assessments do |t|
      t.references :patient, foreign_key: true
      
      # Медицинские поля
      t.integer :heart_rate_mother
      t.string :blood_pressure
      t.integer :respiration_rate_mother
      t.integer :spo2
      t.float :temperature
      t.string :consciousness
      t.boolean :convulsions
      t.string :bloody_discharge
      t.integer :fetal_heart_rate
      t.boolean :umbilical_cord_prolapse
      t.boolean :acute_pain
      t.boolean :delivering_baby
      t.integer :gestational_age
      t.boolean :contractions
      t.boolean :irregular_contractions
      t.boolean :water_breakage
      t.string :fetal_position
      t.boolean :multiple_pregnancy
      t.boolean :hiv
      t.boolean :herpes
      t.boolean :placenta_previa
      t.boolean :planned_cs
      t.boolean :recent_trauma
      t.boolean :requires_transfer
      t.boolean :normal_pregnancy_complaints
      t.boolean :no_complaints
      
      t.timestamps
    end
  end
end