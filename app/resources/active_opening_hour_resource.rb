class ActiveOpeningHourResource < JSONAPI::Resource

  model_name 'OpeningHour'

  attributes :day_of_week_index, :closed, :opening_time, :closing_time

  filter :library, apply: ->(records, value, _options) {
    records.joins(:rule).where('rules.library_id = ?', value)
  }

  filter :date, apply: -> (records, value, _options) {
    date_obj = Date.parse(value.first)
    day_index = date_obj.strftime("%u").to_i - 1
    libraries = Library.all
    rule_ids = []
    libraries.each do |lib|
      rule = lib.rule_for_date(date: value.first)
      rule_ids << rule.id if rule
    end
    records = records.where(rule_id: rule_ids)
    records = records.where(day_of_week_index: day_index)
    return records
  }

  has_one :rule
  #has_one :library, relation_name: :library

  def opening_time
    return @model.opening_time.to_s.present? ? @model.opening_time.strftime("%H:%M") : nil
  end
  def closing_time
    return @model.closing_time.to_s.present? ? @model.closing_time.strftime("%H:%M") : nil
  end
end
