class ChangeHourDataType < ActiveRecord::Migration
  def self.up
	change_column "hours", "normal", :integer
	change_column "hours", "rate2", :integer
	change_column "hours", "rate3", :integer
	change_column "hours", "travel", :integer
  end

  def self.down
	change_column "hours", "normal", :time
	change_column "hours", "rate2", :time
	change_column "hours", "rate3", :time
	change_column "hours", "travel", :time
  end
end
