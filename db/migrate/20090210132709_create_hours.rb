class CreateHours < ActiveRecord::Migration
  def self.up
    create_table :hours do |t|
      t.integer :timesheet_id
      t.integer :day, :null => false
      t.string :detail
      t.time :normal
      t.time :travel
      t.time :rate2
      t.time :rate3

      t.timestamps
    end
  end

  def self.down
    drop_table :hours
  end
end
