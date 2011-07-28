class Project < ActiveRecord::Base
  has_many :timesheet
  belongs_to :customer
end
