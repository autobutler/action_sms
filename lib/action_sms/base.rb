module ActionSms
  # Implementation
  class Base < AbstractController::Base
    class << self
      def respond_to?(method, include_private = false) #:nodoc:
        super || action_methods.include?(method.to_s)
      end

    protected

      def method_missing(method, *args)
        return super unless respond_to?(method)
        new(method, *args).message
      end
    end

    attr_internal :message

    def initialize(method_name=nil, *args)
      super()
      @_message = SMS.new
      process(method_name, *args) if method_name
    end

    def process(*args) #:nodoc:
      lookup_context.skip_default_locale!
      super
    end

    def sms(headers={})
      m = @_message

      assignable = headers.except(:body)
      assignable.each { |k, v| m[k] = v }

      m.body = gather_body(headers)
      m
    end

    def gather_body(headers)
      responses = []
      if headers[:body]
        responses << headers.delete(:body)
      else
        templates_path = headers.delete(:template_path) || self.class.mailer_name
        templates_name = headers.delete(:template_name) || action_name

        each_template(templates_path, templates_name) do |template|
          next unless template.mime_type.to_s == "text/plain"
          self.formats = template.formats

          responses << render(:template => template)
        end
      end
      responses.join(" ")
    end

    def each_template(paths, name, &block) #:nodoc:
      templates = lookup_context.find_all(name, Array.wrap(paths))
      templates.uniq_by { |t| t.formats }.each(&block)
    end
  end
end
