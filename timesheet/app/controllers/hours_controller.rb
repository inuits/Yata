class HoursController < ApplicationController

  # GET /hours/1/edit
  def edit
    @hour = Hour.find(params[:id])
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
