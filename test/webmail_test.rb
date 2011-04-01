require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class WebmailTest < Test::Unit::TestCase

  def test_basic_email
    email = Rack::Mailer::Webmail.new('joe@example.com', {:foo => 'bar', :baz => 'boo'})
    assert_equal ['joe@example.com'], email.to
    assert_equal ['joe@example.com'], email.from
    assert_kind_of Mail::SMTP, email.delivery_method
    assert_equal <<MSG.chop, email.body.to_s
A message was received on the website:

foo: bar
baz: boo
MSG
  end

  def test_custom_intro
    email = Rack::Mailer::Webmail.new('joe@example.com', {}, {:intro => 'This just in:'})
    assert_equal 'This just in:', email.body.to_s
  end

  def test_delivery_method
    email = Rack::Mailer::Webmail.new('joe@example.com', {}, {:delivery_method => :sendmail})
    assert_kind_of Mail::Sendmail, email.delivery_method
  end

  def test_custom_from
    email = Rack::Mailer::Webmail.new('joe@example.com',
      {:email => 'jane@example.com'}, {:from => 'jack@example.com'})
    assert_equal ['jack@example.com'], email.from
  end

  def test_form_from
    email = Rack::Mailer::Webmail.new('joe@example.com', {:email => 'jane@example.com'})
    assert_equal ['jane@example.com'], email.from
  end

end
