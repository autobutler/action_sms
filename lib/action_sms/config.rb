module ActionSms
  module Config
    attr_writer :options
    
    def provider=(name)
      @provider = ActionSms::Providers.const_get(name.to_s.camelize + "Provider")
    end
    
    def provider
      @provider ||= ActionSms::Providers::TestProvider
    end
    
    def options
      @options ||= {}
    end
    
    def logger
      @logger ||= if defined?(Rails.logger)
        Rails.logger
      elsif defined?(RAILS_DEFAULT_LOGGER)
        RAILS_DEFAULT_LOGGER
      else
        Logger.new(STDOUT)
      end
    end
  end
end