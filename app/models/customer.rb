class Customer < ActiveRecord::Base
  has_many :timesheet
  has_many :project
end
