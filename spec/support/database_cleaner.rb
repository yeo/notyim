# frozen_string_literal: true

require 'database_cleaner'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.orm = 'mongoid'
