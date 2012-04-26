class CountriesController < ApplicationController
  def new
  	@countries = Country.new
 
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @countries }
    end
  end

  def create
    @countries = Country.new(params[:country])
    if @countries.save
      redirect_to '/static_pages/mygraph'
    else
      redirect_to '/countries/new'
    end
  end

end