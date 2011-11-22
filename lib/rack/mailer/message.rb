# Extends a Mail::Message so the params can be passed to "deliver". Also
# provides defaults for everything but "to" so less needs to be specified
# unless desired.
class Rack::Mailer::Message < Mail::Message

  # Follows same interface as Mail::Message except defaults set.
  def initialize *args, &blk
    super *args do
      subject "Website Message"
      body "A message was received on the website:\n\n"
    end
    instance_eval &blk if block_given?
  end

  # Like Mail::Message.deliver only the params are passed in to be appended.
  # Note that params are not a hash but array of arrays. This way the order
  # can be specified.
  def deliver params=[]
    self.from ||= params.assoc('email').last if params.assoc('email')
    self.from ||= to
    self.body = self.body.to_s + data(params)
    super()
  end

  private

  def data params=[]
    text = []
    params.collect do |(key, value)|
      # Don't make it a hard dependency. Just use it if it exists
      key = key.titleize if key.respond_to? :titleize
      if is_upload? value
        attachments[value[:filename]] = value[:tempfile].read
      else
        text << "#{key}: #{value}"
      end
    end
    text * "\n"
  end

  def is_upload?(value)
    value.respond_to?(:has_key?) && value.has_key?(:filename) && value.has_key?(:tempfile)
  end

end
