class Customer < ActiveRecord::Base
  has_many :timesheet
end
