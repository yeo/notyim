require "rails_helper"

RSpec.describe ReceiversController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/receivers").to route_to("receivers#index")
    end

    it "routes to #new" do
      expect(:get => "/receivers/new").to route_to("receivers#new")
    end

    it "routes to #show" do
      expect(:get => "/receivers/1").to route_to("receivers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/receivers/1/edit").to route_to("receivers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/receivers").to route_to("receivers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/receivers/1").to route_to("receivers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/receivers/1").to route_to("receivers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/receivers/1").to route_to("receivers#destroy", :id => "1")
    end

  end
end
