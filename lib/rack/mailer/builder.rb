# Provides a DSL for specifying the e-mail specs easily. A few rules:
#
# * The only thing you MUST specify is who the e-mail goes to.
# * The from if not specified will use the "email" field from the params. If
#   that is not specified the "to" address will be used.
# * The subject will default to "Website Message"
class Rack::Mailer::Builder
  extend Forwardable
  extend Rack::Mailer::DslAccessor

  # The deliver message that the builder is managing
  attr_reader :message
  def_delegators :@message, :to, :from, :subject, :delivery_method

  # The URL to send the user after an attempted delivery. If not specified
  # then just a simple success/failure message is outputted. Also have an
  # attribute that controls the order they appear in the e-mail
  dsl_accessor :success_url, :failure_url, :order

  def initialize
    @message = Rack::Mailer::Message.new
  end

  # Allows an auto_responder to be configured. The block will be executed in
  # the context of a Mail::Message (allowing the to, from, subject, etc to be
  # set) and the params from the request will be passed in.
  def auto_responder(&blk)
    @auto_responder = blk if block_given?
    @auto_responder
  end

end