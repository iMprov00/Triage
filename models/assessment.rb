class Assessment < ActiveRecord::Base
  belongs_to :patient

  # Валидации числовых полей
  validates :heart_rate_mother, numericality: { only_integer: true, allow_nil: true }
  validates :spo2, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  # ... добавьте остальные валидации по аналогии

   PRIORITY_CONDITIONS = {
    1 => [
      ->(a) { a.heart_rate_mother && (a.heart_rate_mother < 40 || a.heart_rate_mother > 130) },
      ->(a) { a.blood_pressure =~ /(\d+)\/(\d+)/ && ($1.to_i >= 160 || $2.to_i >= 110) },
      ->(a) { a.respiration_rate_mother && a.respiration_rate_mother == 0 }, # апное
      ->(a) { a.spo2 && a.spo2 < 93 },
      ->(a) { a.temperature && (a.temperature > 41 || a.temperature < 35) },
      ->(a) { a.consciousness == 'отсутствует' },
      ->(a) { a.convulsions },
      ->(a) { a.bloody_discharge == 'алые непрерывные' },
      ->(a) { a.fetal_heart_rate && a.fetal_heart_rate <= 110 },
      ->(a) { a.umbilical_cord_prolapse },
      ->(a) { a.delivering_baby }
    ],
    2 => [
      ->(a) { a.heart_rate_mother && (a.heart_rate_mother < 50 || a.heart_rate_mother > 120) },
      ->(a) { a.blood_pressure =~ /(\d+)\/(\d+)/ && ($1.to_i >= 140 || $2.to_i >= 90) && a.symptomatic? }, # симптомное АД (нужно определить метод symptomatic?)
      ->(a) { a.respiration_rate_mother && a.respiration_rate_mother == 0 }, # апное
      ->(a) { a.spo2 && a.spo2 <= 95 },
      ->(a) { a.temperature && a.temperature > 38.3 },
      ->(a) { a.consciousness == 'измененное' },
      ->(a) { a.bloody_discharge == 'умеренные' },
      ->(a) { a.fetal_heart_rate && a.fetal_heart_rate >= 160 },
      ->(a) { a.gestational_age && a.gestational_age < 34 && a.contractions },
      ->(a) { a.gestational_age && a.gestational_age < 34 && a.water_breakage },
      ->(a) { a.gestational_age && a.gestational_age >= 34 && (a.contractions || a.water_breakage) && (a.hiv || a.planned_cs || a.fetal_position == 'тазовое' || a.multiple_pregnancy || a.placenta_previa) },
      ->(a) { a.recent_trauma },
      ->(a) { a.requires_transfer },
      ->(a) { a.acute_pain }
    ],
    3 => [
      ->(a) { a.blood_pressure =~ /(\d+)\/(\d+)/ && ($1.to_i >= 140 || $2.to_i >= 90) && !a.symptomatic? }, # асимптомное АД
      ->(a) { a.temperature && a.temperature > 38.0 },
      ->(a) { a.contractions && a.gestational_age && a.gestational_age >= 34 },
      ->(a) { (a.irregular_contractions || a.water_breakage) && a.gestational_age && a.gestational_age >= 34 && a.gestational_age <= 36.6 },
      ->(a) { a.contractions && a.gestational_age && a.gestational_age >= 34 && a.uterine_scar? }, # рубец на матке (нужно определить метод uterine_scar?)
      ->(a) { a.multiple_pregnancy && a.irregular_contractions && a.gestational_age && a.gestational_age >= 34 },
      ->(a) { a.contractions && a.gestational_age && a.gestational_age >= 30 && a.herpes } # первичный эпизод герпеса? (упрощенно)
    ],
    4 => [
      ->(a) { (a.irregular_contractions || a.water_breakage) && a.gestational_age && a.gestational_age > 37 },
      ->(a) { a.normal_pregnancy_complaints }
    ],
    5 => [
      ->(a) { a.no_complaints }
    ]
  }

    # Динамическое вычисление приоритета
  def calculate_priority
    (1..5).each do |priority|
      conditions = PriorityCondition.for_priority(priority).active
      if meets_conditions?(conditions)
        return priority
      end
    end
    5 # по умолчанию
  end
  
  private
  
  def meets_conditions?(conditions)
    return false if conditions.empty?
    
    conditions.group_by(&:logical_operator).each do |operator, group|
      case operator
      when 'and'
        return false unless group.all? { |condition| check_condition(condition) }
      when 'or'
        return true if group.any? { |condition| check_condition(condition) }
      else
        # По умолчанию AND
        return false unless group.all? { |condition| check_condition(condition) }
      end
    end
    
    true
  end
  
  def check_condition(condition)
    value = send(condition.parameter_code)
    compare_values(value, condition.operator, condition.value)
  end
  
  def compare_values(actual, operator, expected)
    case operator
    when '=='
      actual == convert_value(expected, actual.class)
    when '!='
      actual != convert_value(expected, actual.class)
    when '>'
      actual > convert_value(expected, actual.class)
    when '<'
      actual < convert_value(expected, actual.class)
    when '>='
      actual >= convert_value(expected, actual.class)
    when '<='
      actual <= convert_value(expected, actual.class)
    when 'contains'
      actual.to_s.include?(expected.to_s)
    when 'starts_with'
      actual.to_s.start_with?(expected.to_s)
    else
      false
    end
  end
  
  def convert_value(value, target_class)
    case target_class.name
    when 'Integer'
      value.to_i
    when 'Float'
      value.to_f
    when 'TrueClass', 'FalseClass'
      value.downcase == 'true'
    else
      value
    end
  end
end