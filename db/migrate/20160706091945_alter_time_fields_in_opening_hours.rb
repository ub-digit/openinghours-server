class AlterTimeFieldsInOpeningHours < ActiveRecord::Migration
  def change
    remove_column :opening_hours, :type
    remove_column :opening_hours, :timestamps
    add_column :opening_hours, :closed, :boolean
    add_column :opening_hours, :opening_time, :time
    add_column :opening_hours, :closing_time, :time
  end
end
