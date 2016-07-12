class OpeningHourResource < JSONAPI::Resource
  attributes :day_of_week_index, :closed, :opening_time, :closing_time

  has_one :rule

  def opening_time
    return @model.opening_time.to_s.present? ? @model.opening_time.strftime("%H:%M") : nil
  end

  def closing_time
    return @model.closing_time.to_s.present? ? @model.closing_time.strftime("%H:%M") : nil
  end
end
