require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe "library" do
    it {should belong_to(:library)}
  end
  describe "startdate" do
    it {should validate_presence_of(:startdate)}
  end
  describe "enddate" do
    context "for a rule that is an exception" do
      subject { build(:rule, ruletype: "EXCEPTION") }
      it {should validate_presence_of(:enddate)}
    end
    context "for a rule that is a regular rule" do
      subject { build(:rule, ruletype: "REGULAR") }
      it {should_not validate_presence_of(:enddate)}
    end
    context "for a startdate set today" do
      subject { build(:rule, startdate: Date.today) }
      it {should allow_value(Date.today + 1).for(:enddate)}
      it {should_not allow_value(Date.today - 1).for(:enddate).with_message("cannot be before start date")}
    end
  end
  describe "ruletype" do
    # bug in shoulda
    #it {should validate_inclusion_of(:type).in_array(["REGULAR", "EXCEPTION"])}
  end
  describe "opening_hours" do
    it {should have_many(:opening_hours)}
  end
  describe "opening_hours_for_date" do
    context "there are no opening hours for the given date" do
      it "should return nil" do
        rule = create(:rule, ruletype: "REGULAR", startdate: "2016-06-01")
        opening_hour = create(:opening_hour, rule: rule, day_of_week_index: 0)

        result = rule.opening_hours_for_date(date: "2016-07-12")

        expect(result).to be nil
      end
    end
    context "there are opening hours for the given date" do
      it "should return an opening hour object" do
        rule = create(:rule, ruletype: "REGULAR", startdate: "2016-06-01")
        opening_hour = create(:opening_hour, rule: rule, day_of_week_index: 0)

        result = rule.opening_hours_for_date(date: "2016-07-11")

        expect(result).to be_a OpeningHour
        expect(result.id).to eq opening_hour.id
      end
    end
  end
end
