class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.integer :authuser_id, :null => false
      t.integer :customer_id, :null => false
      t.integer :year, :null => false, :default => Time.now.year
      t.integer :month, :null => false, :default => Time.now.mon

      t.timestamps
    end
  end

  def self.down
    drop_table :timesheets
  end
end
