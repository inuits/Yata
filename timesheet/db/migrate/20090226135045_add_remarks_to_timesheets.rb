class AddRemarksToTimesheets < ActiveRecord::Migration
  def self.up
    add_column :timesheets, :remarks, :string, :limit => 250 
  end

  def self.down
    remove_column :timesheets, :remarks
  end
end
