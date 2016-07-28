class AuthusersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def index
    if logged_in? and current_authuser.admin
      @authusers = Authuser.find(:all)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @authusers }
        format.json  { render :json => @authusers }
      end
    else
      redirect_back_or_default('/')
    end
  end
  # render new.rhtml
  def new
  end

  # GET /authusers/1
  def show
    @authuser = Authuser.find(params[:id])
  end

  # GET /authusers/1/toggleadmin
  def toggleadmin
    if logged_in? and current_authuser.admin
      @authuser = Authuser.find(params[:id])
        if @authuser.admin and @authuser != current_authuser
          @authuser.admin = false
        elsif @authuser != current_authuser
          @authuser.admin = true
        end
      @authuser.save()
      redirect_to(authusers_path)
    else
      redirect_back_or_default('/')
    end
  end

  # GET /authusers/edit
  def edit
    if logged_in? and current_authuser.admin
      @authuser = Authuser.find(params[:id])
    elsif logged_in?
      @authuser = current_authuser
    else
      redirect_back_or_default('/')
    end
  end


  # PUT /authuser/1
  # PUT /authuser/1.xml
  def update
    if logged_in? and current_authuser.admin
      @authuser = Authuser.find(params[:id])
    elsif logged_in?
      @authuser = current_authuser
    end
    if logged_in?
      respond_to do |format|
        if @authuser.update_attributes(params[:authuser])
          flash[:notice] = 'Your preferences were successfully updated.'
          format.html { redirect_to(@authuser) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @authuser.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'Your are not allowed to update this user.'
      redirect_back_or_default('/')
    end
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @authuser = Authuser.new(params[:authuser])
    @authuser.save
    if @authuser.errors.empty?
      self.current_authuser = @authuser
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

end
