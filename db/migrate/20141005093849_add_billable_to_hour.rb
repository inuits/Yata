class AddBillableToHour < ActiveRecord::Migration
  def self.up
    add_column :hours, :nonbillable, :boolean
  end

  def self.down
    remove_column :hours, :nonbillable
  end
end
