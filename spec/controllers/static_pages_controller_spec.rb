require 'spec_helper'

describe StaticPagesController do

  describe "GET 'mygraph'" do
    it "returns http success" do
      get 'mygraph'
      response.should be_success
    end
  end

end
