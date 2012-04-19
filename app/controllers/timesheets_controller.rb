class TimesheetsController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => :show

  # GET /timesheets
  # GET /timesheets.xml
  def index
    @timesheets = Timesheet.find_all_by_authuser_id(current_authuser, :order => "year DESC, month DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timesheets }
    end
  end

  # GET /timesheets/all
  # GET /timesheets/all.xml
  def all
    if logged_in? and current_authuser.admin
      if params[:year].nil?
        @year= Time.now.year
      else
        @year= params[:year].to_i
      end
      @timesheets = Timesheet.find_all_by_year(@year, :order => "year, month desc, authuser_id")
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @timesheets }
      end
    else
      redirect_back_or_default('/')
    end
  end

  # GET /timesheets/1
  # GET /timesheets/1.xml
  def show
    @timesheet = Timesheet.find(params[:id])
    @hour = Hour.new
    @hour.day= Time.now.day
    @hour.normal= 8

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timesheet.to_xml(:include => [ :hours ]) }
    end
  end

  # GET /timesheets/new
  # GET /timesheets/new.xml
  def new
    @timesheet = Timesheet.new
    @timesheet.month = Time.now.mon
    @timesheet.year = Time.now.year
    @projects = Project.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @timesheet }
    end
  end

  # POST /timesheets/update_project_div
  def update_project_div
    @projects = Project.find(:all, :conditions => ["customer_id = ?", params[:timesheet_customer_id]])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /timesheets/1/edit
  def edit
    @timesheet = Timesheet.find(params[:id])
    @projects = Project.find(:all, :conditions => ["customer_id = ?", @timesheet.customer_id])
  end


  # POST /timesheets
  # POST /timesheets.xml
  def create
    puts params[:timesheet]
    @timesheet = Timesheet.new(params[:timesheet])
    @timesheet.authuser_id = current_authuser.id

    respond_to do |format|
      if @timesheet.save
        flash[:notice] = 'Timesheet was successfully created.'
        format.html { redirect_to(@timesheet) }
        format.xml  { render :xml => @timesheet, :status => :created, :location => @timesheet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @timesheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /timesheets/1
  # PUT /timesheets/1.xml
  def update
    @timesheet = Timesheet.find(params[:id])

    respond_to do |format|
      if @timesheet.update_attributes(params[:timesheet])
        flash[:notice] = 'Timesheet was successfully updated.'
        format.html { redirect_to(@timesheet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @timesheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /timesheets/1
  # DELETE /timesheets/1.xml
  def destroy
    @timesheet = Timesheet.find(params[:id])
    @timesheet.destroy

    respond_to do |format|
      format.html { redirect_to(timesheets_url) }
      format.xml  { head :ok }
    end
  end

  def create_hour
    @hour = Hour.new(params[:hour])
    @hour.timesheet_id= params[:id]
    if @hour.save
      render :partial => 'hour', :object => @hour
    end
  end

  def user
    @month= params[:month].to_i
    @year= params[:year].to_i

    @day = Array.new
    @timesheets= Timesheet.find_all_by_authuser_id_and_year_and_month(params[:id], @year, @month)

    for timesheet in @timesheets
      num= @timesheets.index(timesheet)
      @hours= Hour.find_all_by_timesheet_id(timesheet.id)

      for hour in @hours
        @day[hour.day] = Array.new(@timesheets.size) if @day[hour.day].nil?

        if @day[hour.day][num].nil?
          @day[hour.day][num]= Hash.new 
        end
        if @day[hour.day][num]["normal"].nil?
          @day[hour.day][num]["normal"] = hour.normal unless hour.normal.nil?
        else
          @day[hour.day][num]["normal"] += hour.normal unless hour.normal.nil?
        end

        if @day[hour.day][num]["rate2"].nil?
          @day[hour.day][num]["rate2"] = hour.rate2 unless hour.rate2.nil?
        else
          @day[hour.day][num]["rate2"] += hour.rate2 unless hour.rate2.nil?
        end

        if @day[hour.day][num]["rate3"].nil?
          @day[hour.day][num]["rate3"] = hour.rate3 unless hour.rate3.nil?
        else
          @day[hour.day][num]["rate3"] += hour.rate3 unless hour.rate3.nil?
        end

        if @day[hour.day][num]["travel"].nil?
          @day[hour.day][num]["travel"] = hour.travel unless hour.travel.nil?
        else
          @day[hour.day][num]["travel"] += hour.travel unless hour.travel.nil?
        end
      end
    end
  end

end
