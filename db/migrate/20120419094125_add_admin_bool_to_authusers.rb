class AddAdminBoolToAuthusers < ActiveRecord::Migration
  def self.up
    add_column :authusers, :admin, :boolean
  end

  def self.down
    remove_column :authusers, :admin
  end
end
