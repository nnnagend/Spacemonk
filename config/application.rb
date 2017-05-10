require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'yaml'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Spacemonk
  class Application < Rails::Application

    #SMTP MAILER SETUP
    config.active_record.raise_in_transactional_callbacks = true
    config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default :charset => "utf-8"
    ActionMailer::Base.smtp_settings = {
        :address => "smtp.gmail.com",
        :port => 587,
        :authentication => :plain,
        :domain => 'gmail.com',
        :user_name => 'naveen@spacemonk.com',
        :password => 'Spacemonk@123'
    }
  end
end
