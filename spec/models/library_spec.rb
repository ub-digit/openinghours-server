require 'rails_helper'

RSpec.describe Library, type: :model do

  describe "default_scope" do
    it "should not return deleted libraries" do
      create(:library)
      create(:library, deleted_at: DateTime.yesterday)

      result = Library.all.count

      expect(result).to eq 1
    end
  end
  describe "name_sv" do
    it {should validate_presence_of(:name_sv)}
  end
  describe "name_en" do
    it {should validate_presence_of(:name_en)}
  end
  describe "rules" do
    it {should have_many(:rules)}
  end

  describe "rule_for_date" do
    context "there is no rule for the given date" do
      it "should return nil" do
        library = create(:library)

        result = library.rule_for_date(date: "2017-01-01")

        expect(result).to be nil
      end
    end
    context "there is one rule for the given date" do
      it "should return a rule object" do
        library = create(:library)
        rule = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-01-01"))
        opening_hour1 = create(:opening_hour, rule: rule, day_of_week_index: 0)
        opening_hour2 = create(:opening_hour, rule: rule, day_of_week_index: 1)
        opening_hour3 = create(:opening_hour, rule: rule, day_of_week_index: 2)
        opening_hour4 = create(:opening_hour, rule: rule, day_of_week_index: 3)
        opening_hour5 = create(:opening_hour, rule: rule, day_of_week_index: 4)
        opening_hour6 = create(:opening_hour, rule: rule, day_of_week_index: 5)
        opening_hour7 = create(:opening_hour, rule: rule, day_of_week_index: 6)

        result = library.rule_for_date(date: "2017-01-01")

        expect(result).to be_a Rule
        expect(result.id).to eq rule.id
      end
    end
    context "there are two rules for the given date" do
      it "should return the rule with the last startdate" do
        library = create(:library)
        rule1 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-01-01"))
        rule2 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))
        create(:opening_hour, rule: rule1, day_of_week_index: 0)
        create(:opening_hour, rule: rule1, day_of_week_index: 1)
        create(:opening_hour, rule: rule1, day_of_week_index: 2)
        create(:opening_hour, rule: rule1, day_of_week_index: 3)
        create(:opening_hour, rule: rule1, day_of_week_index: 4)
        create(:opening_hour, rule: rule1, day_of_week_index: 5)
        create(:opening_hour, rule: rule1, day_of_week_index: 6)

        create(:opening_hour, rule: rule2, day_of_week_index: 0)
        create(:opening_hour, rule: rule2, day_of_week_index: 1)
        create(:opening_hour, rule: rule2, day_of_week_index: 2)
        create(:opening_hour, rule: rule2, day_of_week_index: 3)
        create(:opening_hour, rule: rule2, day_of_week_index: 4)
        create(:opening_hour, rule: rule2, day_of_week_index: 5)
        create(:opening_hour, rule: rule2, day_of_week_index: 6)

        result = library.rule_for_date(date: "2017-01-01")

        expect(result.id).to eq rule2.id
      end
    end
    context "there is an exception that starts before a regular rule for the given date" do
      it "should return the exception" do
        library = create(:library)
        rule1 = create(:rule, library: library, ruletype: "EXCEPTION", startdate: Date.parse("2016-01-01"), enddate: Date.parse("2016-03-01"))
        rule2 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))
        create(:opening_hour, rule: rule1, day_of_week_index: 5)
        create(:opening_hour, rule: rule2, day_of_week_index: 0)
        create(:opening_hour, rule: rule2, day_of_week_index: 1)
        create(:opening_hour, rule: rule2, day_of_week_index: 2)
        create(:opening_hour, rule: rule2, day_of_week_index: 3)
        create(:opening_hour, rule: rule2, day_of_week_index: 4)
        create(:opening_hour, rule: rule2, day_of_week_index: 5)
        create(:opening_hour, rule: rule2, day_of_week_index: 6)

        result = library.rule_for_date(date: "2016-02-20")

        expect(result.id).to eq rule1.id
      end
    end
    context "there are no rules containing opening hours for the given date's weekday" do
      it "should return nil" do
        library = create(:library)
        rule1 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-01-01"))
        rule2 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))

        opening_hour1 = create(:opening_hour, rule: rule1, day_of_week_index: 0)
        opening_hour2 = create(:opening_hour, rule: rule2, day_of_week_index: 1)

        result = library.rule_for_date(date: "2016-02-25")

        expect(result).to be nil
      end
    end
    context "there are rules containing opening hours for the given date's weekday" do
      it "should return a rule" do
        library = create(:library)
        rule1 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-01-01"))
        rule2 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))

        opening_hour1 = create(:opening_hour, rule: rule1, day_of_week_index: 0)
        opening_hour2 = create(:opening_hour, rule: rule2, day_of_week_index: 1)

        result = library.rule_for_date(date: "2016-02-22")

        expect(result).to be_a Rule
        expect(result.id).to eq rule1.id
      end
    end
  end
  describe "opening_hours_for_interval" do
    context "for an interval of 3 days" do
      it "should return an array with three hashes" do
        library = create(:library)
        rule = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))
        create(:opening_hour, rule: rule, day_of_week_index: 0)
        create(:opening_hour, rule: rule, day_of_week_index: 1)
        create(:opening_hour, rule: rule, day_of_week_index: 2)
        create(:opening_hour, rule: rule, day_of_week_index: 3)
        create(:opening_hour, rule: rule, day_of_week_index: 4)
        create(:opening_hour, rule: rule, day_of_week_index: 5)
        create(:opening_hour, rule: rule, day_of_week_index: 6)

        result = library.opening_hours_for_interval(from_date: "2016-06-01", number_of_days: 3)

        expect(result).to be_an Array
        expect(result.length).to eq 3
      end
    end
  end
end
