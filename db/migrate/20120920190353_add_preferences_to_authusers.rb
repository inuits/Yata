class AddPreferencesToAuthusers < ActiveRecord::Migration
  def self.up
    add_column :authusers, :min_hours, :decimal, :precision => 3, :scale => 2, :default => 7
    add_column :authusers, :max_hours, :decimal, :precision => 3, :scale => 2, :default => 9
    add_column :authusers, :max_travel_hours, :decimal, :precision => 3, :scale => 2, :default => 3
  end

  def self.down
    remove_column :authusers, :min_hours
    remove_column :authusers, :max_hours
    remove_column :authusers, :max_travel_hours
  end
end
