class AuthusersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def index
    if logged_in? and current_authuser.admin
      @authusers = Authuser.find(:all)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @authusers }
      end
    else
      redirect_back_or_default('/')
    end
  end
  # render new.rhtml
  def new
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
