require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class MailerTest < Test::Unit::TestCase

  def setup
    Mail.defaults {delivery_method :test}
  end

  def teardown
    Mail.defaults {delivery_method :smtp}
  end

  def server(options={}, to='joe@example.com')
    app = Rack::Builder.app do
      run Rack::Mailer.new(to, options)
    end
    @mock = Rack::MockRequest.new app
  end

  def test_basic
    server
    response = @mock.post('/', :params => {:foo => 'bar', :baz => 'boo'})
    assert_equal 200, response.status
    email = Mail::TestMailer.deliveries.last
    assert_equal ['joe@example.com'], email.to
    assert_equal ['joe@example.com'], email.from
    assert_equal <<MSG.chop, email.body.to_s
A message was received on the website:

baz: boo
foo: bar
MSG
  end

  def test_custom_success_page
    server :success_page => '/success'
    response = @mock.post('/')
    assert_equal 301, response.status
    assert_equal '/success', response.headers['Location']
  end

# FIXME: Unsure how to force error. Will revisit this later when
#        validation is added maybe.
#  def test_error
#    server :delivery_method => :invalid
#    response = @mock.post('/')
#    assert_equal 200, response.status
#    assert_equal 'Failed to send', response.body
#  end

end
