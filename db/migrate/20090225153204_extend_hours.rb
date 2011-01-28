class ExtendHours < ActiveRecord::Migration
  def self.up
	change_column "hours", "normal", :decimal, :precision => 4, :scale => 2
	change_column "hours", "rate2", :decimal, :precision => 4, :scale => 2
	change_column "hours", "rate3", :decimal, :precision => 4, :scale => 2
	change_column "hours", "travel", :decimal, :precision => 4, :scale => 2
  end

  def self.down
	change_column "hours", "normal", :decimal, :precision => 3, :scale => 2
	change_column "hours", "rate2", :decimal, :precision => 3, :scale => 2
	change_column "hours", "rate3", :decimal, :precision => 3, :scale => 2
	change_column "hours", "travel", :decimal, :precision => 3, :scale => 2
  end
end
