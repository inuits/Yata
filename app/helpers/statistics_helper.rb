module StatisticsHelper

  def monthnames
    [["Jan", 1], ["Feb", 2], ["Mar", 3], ["Apr", 4], ["May", 5], ["Jun", 6], ["Jul", 7], ["Aug", 8], ["Sep", 9], ["Oct", 10], ["Nov", 11], ["Dec", 12]]
  end

  def monthname(num)
    Date::MONTHNAMES[num]
  end

  def dhm(hours)
    if (hours%8) != 0
      (hours/8).to_i.to_s + "d+"
    else
      (hours/8).to_i.to_s + "d"
    end
  end

  def dhm_2(hours)
    (hours/8).to_i.to_s + "d " + (hours%8).to_i.to_s.rjust(2, '0') + ":" + ((hours*60)%60).to_i.to_s.rjust(2, '0')
  end

end
