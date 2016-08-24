ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def user
    @user ||= users(:safe)
  end

  def contents_of(path, location: Rails.root)
    File.read File.expand_path(path, location)
  end

  def file_contents(path, location: file_path)
    contents_of path, location: location
  end

  def file_path
    File.expand_path 'files', File.dirname(__FILE__)
  end

end

class ActionController::TestCase
  include Devise::TestHelpers
end
