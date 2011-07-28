class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :customer_id, :null => false
      t.string :shortname, :limit => 10
      t.string :name, :null => false


      t.timestamps
    end
    add_column :timesheets, :project_id, :integer, :null => true
  end

  def self.down
    drop_table :projects
    remove_column :timesheets, :project
  end
end
