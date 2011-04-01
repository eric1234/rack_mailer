module Rack

  class Mailer

    def initialize(email, options={})
      @email = email
      @options = options
    end

    def call(env)
      if email(Rack::Request.new(env).params)
        if @options[:success_page]
          redirect_to @options[:success_page]
        else
          output 'Successfully sent'
        end
      else
        output 'Failed to send'
      end
    end

    private

    def email(params)
      email = Webmail.new(@email, params, @options)
      email.deliver
      not email.bounced?
    end

    def redirect_to(path)
      [301, {'Location' => path}, []]
    end

    def output(message)
      [200, {'Content-Type' => 'text/html'}, message]
    end

  end

end

require 'rack/mailer/webmail'
