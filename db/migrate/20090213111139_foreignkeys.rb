require "migration_helpers"

class Foreignkeys < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    foreign_key(:timesheets, :customer_id, :customers)
    foreign_key(:timesheets, :authuser_id, :authusers)
    foreign_key(:hours, :timesheet_id, :timesheets)
  end

  def self.down
    drop_foreign_key(:timesheets, :customer_id)
    drop_foreign_key(:timesheets, :authuser_id)
    drop_foreign_key(:hours, :timesheet_id)
  end
end
