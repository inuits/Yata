class Project < ActiveRecord::Base
  validates_presence_of :name, :shortname

  has_many :timesheet
  belongs_to :customer
end
