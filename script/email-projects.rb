# this script is intented to be run as a cronjob
# with the MAILTO environment variable

print %{

Hello,

This is a mail giving you an overview of the projects for which there is a timesheet during the current and the last month.

}


def dhm_ts(hours)
  days = (hours/8).to_i
  if days < (hours/8)
    return days.to_s + "d+"
  end
  return days.to_s + "d"
end

def print_project_conclusion(project_id, normal, rate2, rate3, travel, max_user_size)
  print "-".ljust(15,"-")
  print "\t"
  print "-".ljust(max_user_size,"-")
  print "\t----\t----\t----\t----\n"
  print "Hours -".ljust(15,"-")
  print "\t"
  print "-".ljust(max_user_size,"-")
  print "\t"
  print normal
  print "\t"
  print rate2
  print "\t"
  print rate3
  print "\t"
  print travel
  print "\n"
  print "Days ".ljust(15,"-")
  print "\t"
  print "-".ljust(max_user_size,"-")
  print "\t"
  print dhm_ts(normal)
  print "\t"
  print dhm_ts(rate2)
  print "\t"
  print dhm_ts(rate3)
  print "\t"
  print dhm_ts(travel)
  print "\n"
  print "\n"
  total_hours = normal + rate2*1.5 + rate3*2
  total_days = total_hours/8
  print "Worked: " + total_hours.to_s + " hours / " + total_days.to_s + " days"
  print "\n"
  project = Project.find(project_id)
  if project.duration
    print "Planned days: " + project.duration.to_s + " / "
    if project.duration < total_days
      print (total_days - project.duration).to_s
      print " TOO MUCH DAYS"
    elsif project.duration > total_days
      print (project.duration - total_days).to_s
      print " days left"
    else
      print "project completed"
    end
    print "\n"
  end
  if project.price_per_day
    print "Price per day: " + project.price_per_day.to_s
    print " / " + (total_days * project.price_per_day).to_s + " EUR used"
    print "\n"
  end
  if project.total_price
    print "Total price: " + project.total_price.to_s + " EUR"
    if project.price_per_day
      price = total_days * project.price_per_day
      print " / used " + price.to_s + " EUR / "
      if price > project.total_price
        print " TOO MUCH MONEY: "
        print (price - project.total_price).to_s
        print " EUR"
      elsif price < project.total_price
        print (project.total_price - price).to_s
        print " EUR left"
      else
        print "project completed"
      end
    end
    print "\n"
  end
end

max_user_size = 0
users = Authuser.all()
users.each do |u|
  if u.fullname.length > max_user_size
    max_user_size = u.fullname.length
  end
end

current_month = Time.now.month
current_year = Time.now.year
if current_month == 1:
  last_month = 12
  last_year = current_year - 1
else
  last_month = current_month - 1
  last_year = current_year
end
timesheets_m = Timesheet.all()
timesheets_m = timesheets_m.select { |ts| ((ts.year == current_year and ts.month == current_month) or (ts.year == last_year and ts.month == last_month)) and (not ts.project.nil?) }
projects = timesheets_m.collect { |ts| ts.project }


timesheets = Timesheet.all()
timesheets = timesheets.select { |ts| not ts.project.nil? and projects.include? ts.project }


timesheets.sort_by {|ts| ts.project.customer.name}
timesheets = timesheets.sort do |a,b|
  if a.customer.name == b.customer.name
    if a.project.name == b.project.name
      if a.year == b.year
        a.month <=> b.month
      else
        a.year <=> b.year
      end
    else
      a.project.name <=> b.project.name
    end
  else
    a.customer.name <=> b.customer.name
  end
end
current_customer=-1
current_customer_name="NONAME"
current_project=-1
project_normal = 0
project_rate2 = 0
project_rate3 = 0
project_travel = 0
timesheets.each do |ts|
  if ts.customer.id != current_customer or ts.project.id != current_project
    if current_customer != -1:
      print_project_conclusion(current_project, project_normal, project_rate2, project_rate3, project_travel, max_user_size)
    end
    project_normal = 0
    project_rate2 = 0
    project_rate3 = 0
    project_travel = 0
  end
  project_normal += ts.total_normal
  project_rate2 += ts.total_rate2
  project_rate3 += ts.total_rate3
  project_travel += ts.total_travel
  if not ts.customer.id == current_customer
    current_customer_name=ts.customer.name
    current_customer = ts.customer.id
    current_project = -1
    print "\n-".ljust(20,"-")
    print "\n"
  end
  if not ts.project.id == current_project
    print "\nCustomer: "
    print current_customer_name
    print "\nProject: "
    print ts.project.name
    print "\n"
    print "\n"
    current_project = ts.project.id
  end
  print Date::MONTHNAMES[ts.month]
  print " "
  print ts.year
  print "\t"
  print ts.authuser.fullname.ljust(max_user_size)
  print "\t"
  print ts.total_normal
  print "\t"
  print ts.total_rate2
  print "\t"
  print ts.total_rate3
  print "\t"
  print ts.total_travel
  print "\n"
end
print_project_conclusion(current_project, project_normal, project_rate2, project_rate3, project_travel, max_user_size)

print "\n"
print "\n\n\n"
print "The YATA guy\n"
