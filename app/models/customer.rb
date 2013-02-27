class Customer < ActiveRecord::Base
  has_many :timesheet, :dependent => :restrict
  has_many :project, :dependent => :restrict
end
