class Hour < ActiveRecord::Base
  belongs_to :timesheet

  def normal=(value)
    self[:normal] = convert(value)
  end


  def rate2=(value)
    self[:rate2]= convert(value)
  end

  def rate3=(value)
    self[:rate3]= convert(value)
  end

  def travel=(value)
    self[:travel]= convert(value)
  end

  protected

    def convert(value)
      if value.to_s.include? ':'
        v= value.to_s.split(':')
        (v[0].to_f + v[1].to_f/60.0).to_f
      else
        value
      end
    end

end
