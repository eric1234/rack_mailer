require 'forwardable'
require 'mail'

module Rack

  class Mailer

    # The mailer middleware. See Rack::Mailer::Builder for config options.
    def initialize &blk
      @config = blk
    end

    def call env #:nodoc:
      dup._call env
    end

    def _call env #:nodoc:
      @builder = Builder.new
      @builder.instance_eval &@config

      params = Rack::Request.new(env).params

      return output 'Invalid submission.' if invalid? params

      return output "Spam detected." if spam? params

      filter params
      if email reorder(params)
        if @builder.auto_responder
          auto_response = Mail::Message.new
          auto_response.instance_exec params, &@builder.auto_responder
          auto_response.deliver
        end
        output_or_redirect 'Successfully sent', @builder.success_url
      else
        output_or_redirect 'Failed to send', @builder.failure_url
      end
    end

    private

    def filter params
      @builder.field_filter.each {|f| params.delete f}
    end

    # Filtering for likely invalid submissions
    def invalid? params
      params.empty?
    end

    def spam? params
      return false unless @builder.spam_field
      spam_value = params.delete(@builder.spam_field) || ''
      !spam_value.empty?
    end

    def email params
      @builder.message.deliver params
      not @builder.message.bounced?
    end

    def output_or_redirect message, path
      if path
        redirect path
      else
        output message
      end
    end

    def redirect path
      [301, {'Location' => path, 'Content-Type' => ''}, []]
    end

    def output message
      [200, {'Content-Type' => 'text/html'}, [message]]
    end

    def reorder params
      # Prefer explict specification.
      order = @builder.order
      # Then use what form says.
      order = params.delete('order').strip.split(/\s*,\s*/) if !order && params['order']
      # Finally no order
      order ||= []

      params = params.dup
      reordered = []
      for field in order
        reordered << [field, params.delete(field)] if params.has_key? field
      end
      reordered + params.to_a
    end

  end

end

require 'rack/mailer/dsl_accessor'
require 'rack/mailer/builder'
require 'rack/mailer/message'
