class StatisticsController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => :show

  # GET /statistics
  # GET /statistics.xml
  def index
    @timesheets = Timesheet.find_all_by_authuser_id(current_authuser, :order => "year DESC, month DESC")
    @timesheets.sort! { |a,b| a.month <=> b.month || a.customer.name <=> b.customer.name }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timesheets }
    end
  end

  # GET /statistics/all
  # GET /statistics/all.xml
  def all
    if params[:year].nil?
      @year= Time.now.year
    else
      @year= params[:year].to_i
    end
    @timesheets = Timesheet.find_all_by_year(@year)
    if params[:sort].nil?
      @sort = '2'
    else
      @sort = params[:sort]
    end
    if params[:sort].nil? or params[:sort] == '2'
      @timesheets = @timesheets.sort_by { |a| [a.year, a.month*-1, a.authuser_id, a.total_normal*-1, a.total_rate2*-1, a.total_rate3*-1, a.total_travel*-1, a.customer.name] }
    elsif params[:sort] == '12'
      @timesheets = @timesheets.sort_by { |a| [a.year, a.month, a.authuser_id, a.total_normal*-1, a.total_rate2*-1, a.total_rate3*-1, a.total_travel*-1, a.customer.name] }
    elsif params[:sort] == '11'
      @timesheets = @timesheets.sort_by { |a| [a.authuser.fullname*-1, a.customer.name, a.year, a.month*-1, a.total_normal*-1, a.total_rate2*-1, a.total_rate3*-1, a.total_travel*-1] }
    elsif params[:sort] == '1'
      @timesheets = @timesheets.sort_by { |a| [a.authuser.fullname, a.customer.name, a.year, a.month*-1, a.total_normal*-1, a.total_rate2*-1, a.total_rate3*-1, a.total_travel*-1] }
    elsif params[:sort] == '13'
      @timesheets = @timesheets.sort_by { |a| [a.customer.name*-1, a.year, a.month*-1, a.authuser_id, a.total_normal*-1, a.total_rate2*-1, a.total_rate3*-1, a.total_travel*-1] }
    elsif params[:sort] == '3'
      @timesheets = @timesheets.sort_by { |a| [a.customer.name, a.year, a.month*-1, a.total_normal*-1, a.total_rate2*-1, a.total_rate3*-1, a.total_travel*-1, a.authuser_id ] }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timesheets }
    end
  end

end
