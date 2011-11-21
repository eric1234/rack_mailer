require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class MessageTest < Test::Unit::TestCase

  # Our Mailer provides some reasonbly subject and body defaults so they
  # don't have to be specified
  def test_defaults
    email = Rack::Mailer::Message.new
    assert_equal 'Website Message', email.subject
    assert_equal 'A message was received on the website:', email.body.to_s
  end

  # Make sure we didn't fuck up Mail::Message
  def test_consistance_interface
    m = Rack::Mailer::Message.new :from => 'somebody@example.com' do
      subject 'Custom subject'
    end
    assert_equal 'Custom subject', m.subject
    assert_equal ['somebody@example.com'], m.from
  end

  def test_deliver_with_email
    m = Rack::Mailer::Message.new :to => 'joe@example.com'
    m.deliver([['email', 'bob@example.com'], ['foo', 'bar'], ['baz', 'boo']])
    assert_equal ['bob@example.com'], m.from
    assert_equal <<MSG.chop, m.body.to_s
A message was received on the website:

email: bob@example.com
foo: bar
baz: boo
MSG
  end

  def test_from_override
    m = Rack::Mailer::Message.new :to => 'joe@example.com', :from => 'jack@example.com'
    m.deliver([['email', 'bob@example.com'], ['foo', 'bar'], ['baz', 'boo']])
    assert_equal ['jack@example.com'], m.from
    assert_equal <<MSG.chop, m.body.to_s
A message was received on the website:

email: bob@example.com
foo: bar
baz: boo
MSG
  end

  def test_delivery_without_email
    m = Rack::Mailer::Message.new :to => 'joe@example.com'
    m.deliver([['foo', 'bar'], ['baz', 'boo']])
    assert_equal ['joe@example.com'], m.from
    assert_equal <<MSG.chop, m.body.to_s
A message was received on the website:

foo: bar
baz: boo
MSG
  end

end
