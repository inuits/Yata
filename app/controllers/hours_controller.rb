class HoursController < ApplicationController
  before_filter :login_required

  # GET /hours/1/edit
  def edit
    @hour = Hour.find(params[:id])
  end

  # DELETE /hours/1
  # DELETE /hours/1.xml
  def destroy
    @hour = Hour.find(params[:id])
    @timesheet = @hour.timesheet
    @hour.destroy

    respond_to do |format|
      format.html { redirect_to(@timesheet) }
      format.xml  { head :ok }
    end
  end

  # PUT /hours/1
  # PUT /hours/1.xml
  def update
    @hour = Hour.find(params[:id])

    respond_to do |format|
      if @hour.update_attributes(params[:hour])
        flash[:notice] = 'Hour was successfully updated.'
        format.html { redirect_to(@hour.timesheet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hour.errors, :status => :unprocessable_entity }
      end
    end
  end

end
