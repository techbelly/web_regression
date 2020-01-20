require File.join([File.dirname(__FILE__),'lib','web_regression','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'web_regression'
  s.version = WebRegression::VERSION
  s.author = 'Ben Griffiths'
  s.email = 'bengriffiths@gmail.com'
  s.homepage = 'http://techbelly.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Simple guard-friendly utility for diffing web screenshots to make css refactoring easier'
  s.files = %w(
bin/web-regression
  )
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'web-regression'

  s.add_dependency('chunky_png')
  s.add_dependency('grover')

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
