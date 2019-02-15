# frozen_string_literal: true

require 'devdata/user'

module Devdata
  def self.generate
    ::Devdata::UserGenerator.generate
  end
end
