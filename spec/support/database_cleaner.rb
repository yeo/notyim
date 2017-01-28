require 'database_cleaner'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.orm = "mongoid"
