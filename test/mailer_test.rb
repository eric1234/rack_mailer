require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class MailerTest < Test::Unit::TestCase

  def server(&blk)
    app = Rack::Builder.app do
      run Rack::Mailer.new {
        to 'joe@example.com'
        instance_eval &blk if block_given?
      }
    end
    @mock = Rack::MockRequest.new app
  end

  def test_basic
    server
    response = @mock.post('/', :params =>
      {:dog => 'cat', :foo => 'bar', :baz => 'boo', :order => ' baz ,foo, elf'})
    assert_equal 200, response.status
    email = Mail::TestMailer.deliveries.last
    assert_equal ['joe@example.com'], email.to
    assert_equal ['joe@example.com'], email.from
    assert_equal <<MSG.chop, email.body.to_s
A message was received on the website:

baz: boo
foo: bar
dog: cat
MSG
  end

  def test_forced_order
    server {order %w(baz foo)}
    @mock.post('/', :params => {:dog => 'cat', :foo => 'bar', :baz => 'boo'})
    email = Mail::TestMailer.deliveries.last
    assert_equal <<MSG.chop, email.body.to_s
A message was received on the website:

baz: boo
foo: bar
dog: cat
MSG
  end

  def test_custom_destination
    server {success_url '/success'}
    response = @mock.post('/')
    assert_equal 301, response.status
    assert_equal '/success', response.headers['Location']
  end

  def test_auto_responder
    server {
      auto_responder do |params|
        to params['email']
        from 'no-reply@example.com'
        subject 'Your message was received'
        body 'Your message was received. We may or may not get back to you :)'
      end
    }
    @mock.post('/', :params => {:email => 'jane@example.com'})
    email = Mail::TestMailer.deliveries.last
    assert_equal ['jane@example.com'], email.to
    assert_equal ['no-reply@example.com'], email.from
    assert_equal 'Your message was received', email.subject
    assert_equal 'Your message was received. We may or may not get back to you :)', email.body.to_s
  end

  # FIXME: Unsure how to test this as I don't know the reason a message could
  #        be bounced. Maybe once we add validation we can test this better.
  #def test_failure
  #end

end
