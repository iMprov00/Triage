class Patient < ActiveRecord::Base
  has_many :assessments, dependent: :destroy
  
  validates :last_name, :first_name, :birth_date, :admission_date, 
            presence: true
end