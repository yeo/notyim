require "rails_helper"

RSpec.describe AssertionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/assertions").to route_to("assertions#index")
    end

    it "routes to #new" do
      expect(:get => "/assertions/new").to route_to("assertions#new")
    end

    it "routes to #show" do
      expect(:get => "/assertions/1").to route_to("assertions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/assertions/1/edit").to route_to("assertions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/assertions").to route_to("assertions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/assertions/1").to route_to("assertions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/assertions/1").to route_to("assertions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/assertions/1").to route_to("assertions#destroy", :id => "1")
    end

  end
end
