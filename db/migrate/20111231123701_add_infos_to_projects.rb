class AddInfosToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :days, :integer, :null => true
    add_column :projects, :cost, :integer, :null => true
    add_column :projects, :remarks, :string, :limit => 250
    add_column :projects, :end_date, :date, :null => true
    add_column :projects, :fixed_project, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :fixed_project
    remove_column :projects, :end_date
    remove_column :projects, :remarks
    remove_column :projects, :cost
    remove_column :projects, :days
  end
end
