$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "action_sms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "action_sms"
  s.version     = ActionSms::VERSION
  s.authors     = ["Jens Henrik Hertz", "Mads Ohm Larsen"]
  s.email       = ["jens@autobutler.dk", "mads@autobutler.dk"]
  s.homepage    = "http://www.autobutler.dk"
  s.summary     = "Framework for sending SMS messages"
  s.description = "ActionSms is a simple plugin for sending SMS messages, not unlike the way, ActionMailer works."
  s.licenses    = "MIT"

  s.files = Dir["lib/**/*", "CHANGELOG", "README.rdoc", "MIT-LICENSE"]
  s.require_path = 'lib'

  s.add_dependency('rails', '>= 4.0')
  s.add_dependency('rest-client', '>= 1.8.0')

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
end
