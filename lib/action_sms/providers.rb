module ActionSms
  autoload :Provider, 'action_sms/provider'
  
  module Providers
    Dir[File.dirname(__FILE__) + '/providers/**/*.rb'].each do |f|      
      
      # Get camelized class name 
      filename = File.basename(f, '.rb')
      # Add _gateway suffix
      provider_name = filename + '_provider'
      # Camelize the string to get the class name
      provider_class = provider_name.camelize      
      
      # Register for autoloading
      autoload provider_class, f
    end
  end
end