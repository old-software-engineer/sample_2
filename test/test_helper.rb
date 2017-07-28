ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fileutils'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Carrierwave setup and teardown
  carrierwave_template = Rails.root.join('test','fixtures','files')
  carrierwave_root = Rails.root.join('test','support','carrierwave')

  # Carrierwave configuration is set here instead of in initializer
  CarrierWave.configure do |config|
    config.root = carrierwave_root
    config.enable_processing = false
    config.storage = :file
    config.cache_dir = Rails.root.join('test','support','carrierwave','carrierwave_cache')
  end

  # And copy carrierwave template in
  #puts "Copying\n  #{carrierwave_template.join('uploads').to_s} to\n  #{carrierwave_root.to_s}"
  FileUtils.cp_r carrierwave_template.join('uploads'), carrierwave_root

  at_exit do
    #puts "Removing carrierwave test directories:"
    Dir.glob(carrierwave_root.join('*')).each do |dir|
      #puts "   #{dir}"
      FileUtils.remove_entry(dir)
    end
  end

  def assert_save(obj)
    assert obj.save, obj.errors.messages
  end

  def assert_has_error(obj, attribute, errorMessage = "")
    errors = obj.errors.messages[attribute]

    assert_not_empty errors

    unless errorMessage.empty?
      assert_includes errors, errorMessage
    end
  end

  def policy(user, record, action)
    Pundit.policy(user, record).public_send action
  end

  def assert_policy(user, record, action)
    assert policy(user, record, action)
  end

  def assert_not_policy(user, record, action)
    assert_not policy(user, record, action)
  end

  def assert_policy_scope(scope, user, model_class)
    assert_equal scope, Pundit.policy_scope(user, model_class)
  end

  def json_response
    @json_response ||= JSON.parse(@response.body)
  end
end
