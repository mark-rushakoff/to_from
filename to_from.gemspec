require File.expand_path('../lib/to_from', __FILE__)

Gem::Specification.new do |s|
  s.name = 'to_from'
  s.summary = 'Go back and forth between corresponding files in different directories.'
  s.license = 'MIT'
  s.author = 'Mark Rushakoff'
  s.homepage = 'http://github.com/mark-rushakoff/to_from'

  s.version = ToFrom::VERSION

  s.add_runtime_dependency('clip', '~> 1.0')
  s.add_development_dependency('rspec', '~> 2.9')
  s.add_development_dependency('fakefs', '~> 0.4', '> 0.4.0')

  s.executables = ['to_from']
  s.files = Dir.glob('{bin,lib}/**/*')
  s.test_files = Dir.glob('spec/*.rb')
end
