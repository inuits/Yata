class StatisticsController < ApplicationController
  before_filter :admin_required
  protect_from_forgery :except => :show
  require 'fastercsv'

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
      @customer_id= -1
      @project_id= -1
      @month= -1
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml }
      end
      return
    else
      @year= params[:year].to_i
    end
    
    conditions_text = "year = #{@year}"
    
    if not params[:month].nil? and params[:month].to_i != -1
      conditions_text += " AND month = #{params[:month].to_i}"
      @month= params[:month].to_i
    else
      @month= -1
    end
    if not params[:customer_id].nil? and params[:customer_id].to_i != -1
      conditions_text += " AND customer_id = #{params[:customer_id].to_i}"
      @customer_id= params[:customer_id].to_i
      @projects = Project.find(:all, :conditions => ["customer_id = ?", params[:customer_id]])
    else
      @customer_id= -1
    end
    if not params[:project_id].nil? and params[:project_id].to_i > 0
      conditions_text += " AND project_id = #{params[:project_id].to_i}"
      @project_id= params[:project_id].to_i
    elsif not params[:project_id].nil? and params[:project_id].to_i == -2
      conditions_text += " AND project_id is null"
      @project_id= -2
    else
      @project_id= -1
    end
    
    @timesheets = Timesheet.find(:all, :conditions => conditions_text)
    
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

  # GET /statistics/exports
  # GET /statistics/exports.xml
  def exports
    @projects = Project.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timesheets }
    end
  end

  # POST /timesheets/update_project_div
  def update_project_div
    @projects = Project.find(:all, :conditions => ["customer_id = ?", params[:customer_id]])
    respond_to do |format|
      format.html
      format.js
    end 
  end 

  def generate_csv
    if params[:year].nil?
      @year= Time.now.year
    else
      @year= params[:year].to_i
    end
    filename = "yata_#{@year}"
    conditions_text = "year = #{@year}"
    
    if not params[:month].nil? and params[:month].to_i != -1
      conditions_text += " AND month = #{params[:month].to_i}"
      filename += "_#{params[:month].to_i}" 
    end
    if not params[:customer_id].nil? and params[:customer_id].to_i != -1
      conditions_text += " AND customer_id = #{params[:customer_id].to_i}"
      filename += "_customer#{params[:customer_id]}"
    end
    if not params[:project_id].nil? and params[:project_id].to_i > 0
      conditions_text += " AND project_id = #{params[:project_id].to_i}"
      filename += "_project#{params[:project_id]}"
    elsif not params[:project_id].nil? and params[:project_id].to_i == -2
      conditions_text += " AND project_id is null"
      filename += "_noproject"
    end
    csv_data = FasterCSV.generate do |csv|
      if params[:summary_per_month].nil? or params[:summary_per_month].to_i != 1
        csv << ['Id','Consultant login','Consultant name','Customer', 'Project ID', 'Project name', 'Year', 'Month', '100%', '150%', '200%', 'travel']
        @timesheets = Timesheet.find(:all, :conditions => conditions_text)
        @timesheets.each do |t|
          if t.project.nil?
            project_name = "No project"
            project_id = 0
          else
            project_name = t.project.name
            project_id = t.project.id
          end
          csv << [t.id, t.authuser.login, t.authuser.fullname, t.customer.name, project_id, project_name, t.year, t.month, t.total_normal, t.total_rate2, t.total_rate3, t.total_travel]
        end
      else
        @datas = {}
        @timesheets = Timesheet.find(:all, :conditions => conditions_text)
        @timesheets.each do |t|
          if @datas[t.authuser.fullname].nil?
            @datas[t.authuser.fullname] = Array.new(12,0)
          end
          @datas[t.authuser.fullname][t.month-1] += t.total_normal + 1.5 * t.total_rate2 + 2 * t.total_rate3
        end
        @datas.each do | x, y |
          csv << [ x ] + y
        end
      end
    end
      send_data csv_data,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=" + filename + ".csv"
  end

end
