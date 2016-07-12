require 'rails_helper'

RSpec.describe OpeningHour, type: :model do

  describe "day_of_week_index" do
    it {should validate_numericality_of(:day_of_week_index).is_greater_than_or_equal_to(0)}
    it {should validate_numericality_of(:day_of_week_index).is_less_than_or_equal_to(6)}
    it {should_not allow_value(nil).for(:day_of_week_index)}
  end

  describe "rule" do
    it {should belong_to(:rule)}
    it {should validate_presence_of(:rule)}
  end

  describe "day_of_week_index and rule" do
    it {should validate_uniqueness_of(:day_of_week_index).scoped_to(:rule_id)}
  end

  describe "closed" do
    it {should_not allow_value(nil).for(:closed)}
  end

  describe "opening_time, closing_time" do
    context "for a closed day" do
      subject { build(:opening_hour, closed: true) }
      it {should_not validate_presence_of(:opening_time)}
      it {should_not validate_presence_of(:closing_time)}
    end
    context "for an open day" do
      subject { build(:opening_hour, closed: false) }
      it {should validate_presence_of(:opening_time)}
      it {should validate_presence_of(:closing_time)}
    end
  end

  describe "opening_time" do
    context "closing_time is set to 12" do
      subject { build(:opening_hour, closing_time: "12:00:00") }
      it {should_not allow_value("12:00:00").for(:opening_time)}
      it {should_not allow_value("13:00:00").for(:opening_time)}
      it {should allow_value("11:00:00").for(:opening_time)}
    end
  end

  describe "closing_time" do
    context "opening_time is set to 12" do
      subject { build(:opening_hour, opening_time: "12:00:00") }
      it {should_not allow_value("12:00:00").for(:closing_time)}
      it {should_not allow_value("11:00:00").for(:closing_time)}
      it {should allow_value("13:00:00").for(:closing_time)}
    end
  end
end
