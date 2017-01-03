require "rails_helper"

RSpec.describe ChecksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/checks").to route_to("checks#index")
    end

    it "routes to #new" do
      expect(:get => "/checks/new").to route_to("checks#new")
    end

    it "routes to #show" do
      expect(:get => "/checks/1").to route_to("checks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/checks/1/edit").to route_to("checks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/checks").to route_to("checks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/checks/1").to route_to("checks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/checks/1").to route_to("checks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/checks/1").to route_to("checks#destroy", :id => "1")
    end

  end
end
