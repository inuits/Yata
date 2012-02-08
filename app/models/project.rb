class Project < ActiveRecord::Base
  validates_presence_of :name, :shortname
  validates_numericality_of :total_price, :only_integer => false, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :price_per_day, :only_integer => false, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :duration, :only_integer => false, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :duration, :only_integer => false, :greater_than_or_equal_to => 0, :allow_blank => true
  has_many :timesheet
  belongs_to :customer

end
