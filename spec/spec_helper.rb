require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir["spec/support/**/*.rb"].each {|f| require f}

#  RSpec.configure do |config|
#    config.fixture_path = "#{::Rails.root}/spec/fixtures"
#    config.use_transactional_fixtures = true
#    config.infer_base_class_for_anonymous_controllers = false
#  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  require 'action_sms'

end

