require 'mail'

# Extends a Mail::Message object to construct the e-mail based on the
# config and form params easily.
class Rack::Mailer::Webmail < Mail::Message

  def initialize(email, params, options={})
    @params = params
    @options = options
    super do
      from @options[:from] || @params[:email] || email
      to email
      subject "Website Message"
      body data
    end
    delivery_method @options[:delivery_method] if @options.has_key? :delivery_method
  end

  def data
    intro = @options[:intro] || "A message was received on the website:\n\n"
    fields = @params.collect {|(k, v)| "#{k}: #{v}"} * "\n"
    intro + fields
  end

end
