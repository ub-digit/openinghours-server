class CreateOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|
      t.string :type
      t.time :timestamps
      t.integer :day_of_week_index
      t.integer :rule_id
      t.timestamps null: false
    end
  end
end
