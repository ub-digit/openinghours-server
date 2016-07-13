class Library < ActiveRecord::Base
default_scope {where(deleted_at: nil)}

  has_many :rules
  has_many :opening_hours, through: :rules

  validates :name_sv, presence: true
  validates :name_en, presence: true

  def rule_for_date(date:)

    date_obj = Date.parse(date)
    day_index = date_obj.strftime("%u").to_i - 1

    active_rules = self.rules.where("startdate <= ?", date).where("enddate >= ? OR enddate IS NULL", date)
    active_rules = active_rules.includes(:opening_hours).where('opening_hours.day_of_week_index = ?', day_index).references(:opening_hours)
    # sorting assumes "exception" to be alphabetically before "regular"
    active_rules = active_rules.order(ruletype: :asc)
    active_rules = active_rules.order(startdate: :desc)

    return active_rules.first
  end

  def opening_hours_for_interval(from_date:, number_of_days:)

    from_date_obj = Date.parse(from_date)
    to_date_obj = from_date_obj + (number_of_days - 1)

    dates_array = (from_date_obj..to_date_obj).map{ |date| date.strftime("%F")}

    opening_hours_array = []

    dates_array.each do |date|
      rule = rule_for_date(date: date)
      opening_hour = rule ? rule.opening_hours_for_date(date: date) : nil
      if rule && opening_hour
        hash = {
          date: date,
          rulename_sv: rule.name_sv,
          rulename_en: rule.name_en,
          ruletype: rule.ruletype,
          day_of_week_index: opening_hour.day_of_week_index,
          opening_time: opening_hour.opening_time,
          closing_time: opening_hour.closing_time,
          closed: opening_hour.closed
        }
      else
        hash = {
          date: date
        }
      end

      opening_hours_array << hash

    end

    return opening_hours_array

  end
end
