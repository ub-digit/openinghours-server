require "tod"

class OpeningHour < ActiveRecord::Base

  serialize :opening_time, Tod::TimeOfDay
  serialize :closing_time, Tod::TimeOfDay

  belongs_to :rule
  has_one :library, through: :rule

  validates_presence_of :rule
  validates_inclusion_of :closed, in: [true, false]

  validates :day_of_week_index,
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 6},
    uniqueness: {scope: :rule_id},
    allow_nil: false

  validates :opening_time, presence: true, if: :is_open?
  validates :closing_time, presence: true, if: :is_open?

  validate :validate_opening_time_not_after_closing_time
  validate :validate_closing_time_not_before_opening_time

  def validate_opening_time_not_after_closing_time
    if opening_time && closing_time
      if Tod::TimeOfDay.parse(opening_time) >= Tod::TimeOfDay.parse(closing_time)
        errors.add(:opening_time, "cannot be after or same as closing time")
      end
    end
  end

  def validate_closing_time_not_before_opening_time
    if opening_time && closing_time
      if Tod::TimeOfDay.parse(closing_time) <= Tod::TimeOfDay.parse(opening_time)
        errors.add(:closing_time, "cannot be before or same as opening time")
      end
    end
  end

  def opening_time=(time)
    set_value = time ? Tod::TimeOfDay.parse(time) : nil
    write_attribute(:opening_time, set_value)
  end

  def closing_time=(time)
    set_value = time ? Tod::TimeOfDay.parse(time) : nil
    write_attribute(:closing_time, set_value)
  end

  def is_closed?
    closed
  end

  def is_open?
    !closed
  end
end
