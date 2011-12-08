class SeparateProjectsCosts < ActiveRecord::Migration
  def self.up
    remove_column :projects, :cost
    add_column :projects, :cost_per_day, :integer, :null => true
    add_column :projects, :total_cost, :integer, :null => true
  end

  def self.down
    remove_column :projects, :cost_per_day
    remove_column :projects, :total_cost
    add_column :projects, :cost, :integer, :null => true
  end
end
