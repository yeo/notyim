# frozen_string_literal: true

require 'trinity/current'
require 'trinity/policy'

class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user! # , :pick_team!
end
