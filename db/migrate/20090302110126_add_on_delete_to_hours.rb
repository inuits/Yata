require "migration_helpers"

class AddOnDeleteToHours < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    drop_foreign_key(:hours, :timesheet_id)
    foreign_key_cascade(:hours, :timesheet_id, :timesheets)
  end

  def self.down
    drop_foreign_key(:hours, :timesheet_id)
    foreign_key(:hours, :timesheet_id, :timesheets)
  end
end
