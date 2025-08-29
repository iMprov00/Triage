class TriageParameter < ActiveRecord::Base
  validates :name, :code_name, :data_type, presence: true
  validates :code_name, uniqueness: true
  
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, id: :asc) }
end

class PriorityCondition < ActiveRecord::Base
  validates :priority_level, :parameter_code, :operator, presence: true
  validates :priority_level, inclusion: { in: 1..5 }
  
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(priority_level: :asc, position: :asc) }
  scope :for_priority, ->(level) { where(priority_level: level).ordered }
end