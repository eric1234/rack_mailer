require 'forwardable'
require 'mail'

module Rack

  class Mailer

    # The mailer middleware. See Rack::Mailer::Builder for config options.
    def initialize &blk
      @builder = Builder.new
      @builder.instance_eval &blk
    end

    def call env #:nodoc:
      params = Rack::Request.new(env).params

      # Prefer explict specification. Then use what form says. Finally no order
      order = @builder.order
      order = params.delete('order').strip.split(/\s*,\s*/) if !order && params['order']
      order ||= []

      if email reorder(params, order)
        if @builder.auto_responder
          auto_response = Mail::Message.new
          auto_response.instance_exec params, &@builder.auto_responder
          auto_response.deliver
        end
        output_or_redirect @builder.success_url, 'Successfully sent'
      else
        output_or_redirect @builder.failure_url, 'Failed to send'
      end
    end

    private

    def email params
      @builder.message.deliver params
      not @builder.message.bounced?
    end

    def output_or_redirect(path, message)
      if path
        [301, {'Location' => path}, []]
      else
        [200, {'Content-Type' => 'text/html'}, [message]]
      end
    end

    def reorder(params, order)
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
