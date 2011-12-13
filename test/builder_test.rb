require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class BuilderTest < Test::Unit::TestCase

  def test_forwarding
    b = Rack::Mailer::Builder.new
    tm = b.instance_variable_get '@template_message'

    b.to 'joe@example.com'
    assert_equal ['joe@example.com'], tm.to

    b.from 'jack@example.com'
    assert_equal ['jack@example.com'], tm.from

    b.subject 'A Topic'
    assert_equal 'A Topic', tm.subject

    b.delivery_method :sendmail
    assert_equal Mail::Sendmail, tm.delivery_method.class
  end

  # We want to make sure changes in the new message don't leak back to
  # the template message.
  def test_new_message
    b = Rack::Mailer::Builder.new

    b.to 'joe@example.com'
    assert_nil b.from

    m = b.new_message
    m.from = 'jack@example.com'

    assert_nil b.from
  end

  def test_auto_responder
    b = Rack::Mailer::Builder.new
    b.auto_responder {'foo'}
    assert_equal 'foo', b.auto_responder.call
  end

end