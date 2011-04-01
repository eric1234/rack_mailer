require 'rake/testtask'
require 'rake/gempackagetask'

spec = eval File.read('rack_mailer.gemspec')
Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = false
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = FileList['test/*_test.rb']
end
task :default => :test
