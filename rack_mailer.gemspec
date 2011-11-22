Gem::Specification.new do |s|
  s.name = 'rack_mailer'
  s.version = '0.0.6'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'rack'
  s.add_dependency 'mail'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'ruby-debug'
  s.files = Dir['lib/**/*.rb']
  s.has_rdoc = true
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'Rack-based handler for mail forms'
  s.description = <<-DESCRIPTION
    Provides a simple mail for script in the form of a Rack end-point.
    Right now is pretty basic, featureless and probably somewhat
    vulnerable to spam, etc.
  DESCRIPTION
end
