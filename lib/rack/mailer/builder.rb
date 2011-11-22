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
  def_delegators :@message, :to, :from, :subject, :body, :delivery_method

  # The URL to send the user after an attempted delivery. If not specified
  # then just a simple success/failure message is outputted.
  dsl_accessor :success_url, :failure_url, :order, :spam_field

  # Controls the order they appear in the e-mail. You can also specify this
  # via the form if that is easier using a param called "order"
  dsl_accessor :order

  # To help prevent spam. If set then this field will be verified that the
  # value is empty?. If it is not then the submission will be rejected. You
  # should hide this field using CSS so an end user doesn't see it but a bot
  # will. Most bots will fill out all fields in hopes to pass validation.
  #
  # To hide via CSS you should not do it inline (some bots will detect that).
  # Also hiding via moving off-screen is harder for a bot to detect than using
  # display: none.
  #
  # Finally any CSS class or field name should look normal. Don't use things
  # like "anti-spam". Instead using something that a bot might think needs to
  # be filled out like "full_name".
  #
  # Also set the tabindex to -1 so the user won't accidently tab to this field.
  dsl_accessor :spam_field

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