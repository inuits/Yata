# this script is intented to be run as a cronjob
# with the MAILTO environment variable

print %{
<html><body>
<p>Hello,</p>

<p>This is a mail giving you an overview of the projects for which there is a timesheet during the current and the last month.</p>

}


def dhm_ts(hours)
  days = (hours/8).to_i
  if days < (hours/8)
    return days.to_s + "d+"
  end
  return days.to_s + "d"
end

def print_project_conclusion(project_id, normal, rate2, rate3, travel)
  print "<tr><td colspan=\"2\">"
  print "Hours"
  print "</td><td>"
  print normal
  print "</td><td>"
  print rate2
  print "</td><td>"
  print rate3
  print "</td><td>"
  print travel
  print "</td></tr>"
  print "<tr><td colspan=\"2\">"
  print "Days "
  print "</td><td>"
  print dhm_ts(normal)
  print "</td><td>"
  print dhm_ts(rate2)
  print "</td><td>"
  print dhm_ts(rate3)
  print "</td><td>"
  print dhm_ts(travel)
  print "</td></tr></table><br />"
  total_hours = normal + rate2*1.5 + rate3*2
  total_days = total_hours/8
  print "Worked: " + total_hours.to_s + " hours / " + total_days.to_s + " days"
  print "<br />"
  project = Project.find(project_id)
  if project.duration
    print "Planned days: " + project.duration.to_s + " / "
    if project.duration < total_days
      print "<span style=\"color:red\">"
      print (total_days - project.duration).to_s
      print " TOO MUCH DAYS</span>"
    elsif project.duration > total_days
      print (project.duration - total_days).to_s
      print " days left"
    else
      print "project completed"
    end
    print "<br />"
  end
  if project.price_per_day
    print "Price per day: " + project.price_per_day.to_s
    print " / " + (total_days * project.price_per_day).to_s + " EUR used"
    print "<br />"
  end
  if project.total_price
    print "Total price: " + project.total_price.to_s + " EUR"
    if project.price_per_day
      price = total_days * project.price_per_day
      print " / used " + price.to_s + " EUR / "
      if price > project.total_price
        print "<span style=\"color:red\"> TOO MUCH MONEY: "
        print (price - project.total_price).to_s
        print " EUR</span>"
      elsif price < project.total_price
        print (project.total_price - price).to_s
        print " EUR left"
      else
        print "project completed"
      end
    end
    print "<br />"
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
      print_project_conclusion(current_project, project_normal, project_rate2, project_rate3, project_travel)
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
  end
  if not ts.project.id == current_project
    print "\n<hr /><h2>Customer: "
    print current_customer_name
    print "</h2><h3>Project: "
    print ts.project.name
    print "</h3><br />"
    print "<table><tr><th>Month</th><th>Consultant</th><th>100%</th><th>150%</th><td>200%</th><th>Travel</th></tr>"
    current_project = ts.project.id
  end
  print "<tr><td>"
  print Date::MONTHNAMES[ts.month]
  print " "
  print ts.year
  print "</td><td>"
  print ts.authuser.fullname
  print "</td><td>"
  print ts.total_normal
  print "</td><td>"
  print ts.total_rate2
  print "</td><td>"
  print ts.total_rate3
  print "</td><td>"
  print ts.total_travel
  print "</td></tr>"
end
print_project_conclusion(current_project, project_normal, project_rate2, project_rate3, project_travel)

print "<hr>"
print "<br>"
print "The YATA guy</body></html>"
