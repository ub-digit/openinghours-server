class Rule < ActiveRecord::Base
  belongs_to :library
  has_many :opening_hours

  validates :library, presence: true
  validates :startdate, presence: true
  validates :enddate, presence: true, :if => :is_exception?
  validate :validate_enddate_not_before_startdate
  validates_inclusion_of :ruletype, in: ["REGULAR", "EXCEPTION"]

  def is_exception?
    ruletype == "EXCEPTION"
  end

  def validate_enddate_not_before_startdate
    if enddate.present? && enddate < startdate
      errors.add(:enddate, "cannot be before start date")
    end
  end

  def opening_hours_for_date(date:)

    date_obj = Date.parse(date)
    day_index = date_obj.strftime("%u").to_i - 1

    opening_hours = self.opening_hours.where(day_of_week_index: day_index)

    return opening_hours.first

  end
end
