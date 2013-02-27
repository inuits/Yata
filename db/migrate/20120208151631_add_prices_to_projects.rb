class AddPricesToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :total_price, :integer, :null => true
    add_column :projects, :price_per_day, :integer, :null => true
    add_column :projects, :duration, :integer, :null => true
    add_column :projects, :end_date, :date, :null => true
  end

  def self.down
    remove_column :projects, :total_price
    remove_column :projects, :price_per_day
    remove_column :projects, :duration
    remove_column :projects, :end_date
  end
end
