class AddMissingFieldsToAssessments < ActiveRecord::Migration[6.1]
  def change
    add_column :assessments, :acute_pain_severity, :integer
    add_column :assessments, :reduced_fetal_movement, :boolean
    add_column :assessments, :symptomatic, :boolean
    add_column :assessments, :uterine_scar, :boolean
  end
end