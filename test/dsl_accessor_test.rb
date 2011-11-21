require 'pathname'
require Pathname.new(__FILE__).dirname.join('test_helper')

class DslAccessorTest < Test::Unit::TestCase
  class Dummy
    extend Rack::Mailer::DslAccessor
    dsl_accessor :foo, :bar

    def initialize(foo=nil, bar=nil)
      @foo = foo
      @bar = bar
    end
  end

  def test_reader
    d = Dummy.new('baz', 'boo')
    assert_equal 'baz', d.foo
    assert_equal 'boo', d.bar
  end

  def test_traditional_writer
    d = Dummy.new
    d.foo = 'cat'
    d.bar = 'dog'
    assert_equal 'cat', d.foo
    assert_equal 'dog', d.bar
  end

  def test_dsl_writer
    d = Dummy.new
    d.foo 'cat'
    d.bar 'dog'
    assert_equal 'cat', d.foo
    assert_equal 'dog', d.bar
  end

end