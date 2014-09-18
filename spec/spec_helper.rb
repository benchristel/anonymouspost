# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

module IntegrationHelpers
  extend ActiveSupport::Concern

  included do
    after do
      if @schema && respond_to?(:response_body)
        expect(response_body).to conform_to_schema @schema
      end

      if @status && respond_to?(:response)
        expect(response.status).to eq @status
      end
    end

    def response_body
      JSON response.body
    end
  end
end

RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.include IntegrationHelpers

  config.order = "random"
end
