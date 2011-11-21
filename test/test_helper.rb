require 'pathname'
$LOAD_PATH << Pathname.new(__FILE__).dirname.join('../lib')

require 'test/unit'
require 'rack'
require 'rack/mailer'
require 'active_support/ordered_hash.rb'

Mail.defaults {delivery_method :test}
