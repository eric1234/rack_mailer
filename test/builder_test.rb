require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class BuilderTest < Test::Unit::TestCase

  def test_forwarding
    b = Rack::Mailer::Builder.new

    b.to 'joe@example.com'
    assert_equal ['joe@example.com'], b.message.to

    b.from 'jack@example.com'
    assert_equal ['jack@example.com'], b.message.from

    b.subject 'A Topic'
    assert_equal 'A Topic', b.message.subject
  end

  def test_auto_responder
    b = Rack::Mailer::Builder.new
    b.auto_responder {'foo'}
    assert_equal 'foo', b.auto_responder.call
  end

end
