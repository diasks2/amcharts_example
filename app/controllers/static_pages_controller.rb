class StaticPagesController < ApplicationController
  def mygraph
  	@countries = Country.find(:all)
  end
end
