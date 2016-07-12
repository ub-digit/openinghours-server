class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :library_id, null: false
      t.date :startdate
      t.date :enddate
      t.string :type
      t.string :name_sv
      t.string :name_en
      t.text :description_sv
      t.text :description_en
      t.timestamps null: false
    end
  end
end
