class AddBoolToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :fixed_price, :boolean
    add_column :projects, :billable, :boolean
  end

  def self.down
    remove_column :projects, :fixed_price
    remove_column :projects, :billable
  end
end
