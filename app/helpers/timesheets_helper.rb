module TimesheetsHelper

  def monthnames
    [["Jan", 1], ["Feb", 2], ["Mar", 3], ["Apr", 4], ["May", 5], ["Jun", 6], ["Jul", 7], ["Aug", 8], ["Sep", 9], ["Oct", 10], ["Nov", 11], ["Dec", 12]]
  end

  def monthname(num)
    Date::MONTHNAMES[num]
  end

  def dhm_ts(hours)
    (hours/8).to_i.to_s + "d " + (hours%8).to_i.to_s.rjust(2, '0') + ":" + ((hours*60)%60).to_i.to_s.rjust(2, '0') 
  end

  def allow_edit(timesheet)
    return true if current_authuser.admin

    # allow editing 1 month + 15 days after timesheet date
    # convert to numeric value to be able to compare, just count
    # 31 per month, real month length doesnt matter
    max_edit_date  = timesheet.year*12*31+(timesheet.month+1)*31+15
    cur = Time.now.year*12*31 + Time.now.month*31 + Time.now.day
    cur <= max_edit_date
  end
end
