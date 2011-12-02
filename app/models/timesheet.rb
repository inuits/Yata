class Timesheet < ActiveRecord::Base
  validates_numericality_of :year, :only_integer => false, :greater_than_or_equal_to => 2007, :allow_blank => false
  validates_presence_of :customer_id

  belongs_to :authuser
  belongs_to :customer
  belongs_to :project
  has_many :hours

  def total_normal
    total= 0
    self.hours.each{ |h| total += h.normal unless h.normal.nil? }
    total
  end

  def total_rate2
    total= 0
    self.hours.each{ |h| total += h.rate2 unless h.rate2.nil? }
    total
  end

  def total_rate3
    total= 0
    self.hours.each{ |h| total += h.rate3 unless h.rate3.nil? }
    total
  end

  def total_travel
    total= 0
    self.hours.each{ |h| total += h.travel unless h.travel.nil? }
    total
  end

end
