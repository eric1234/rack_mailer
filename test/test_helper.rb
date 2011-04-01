require 'pathname'
$LOAD_PATH << Pathname.new(__FILE__).dirname.join('../lib')

require 'test/unit'
require 'rubygems'
require 'rack'

require 'rack/mailer'
