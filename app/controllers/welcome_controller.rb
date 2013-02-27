class WelcomeController < ApplicationController
  before_filter :login_required

  def index
    # get a random tip
    @tip = Tip.first(:order => "RAND()")
  end

end
