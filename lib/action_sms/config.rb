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
  end
end