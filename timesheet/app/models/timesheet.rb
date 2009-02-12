class Timesheet < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :customer
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
