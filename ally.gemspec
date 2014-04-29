# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ally/version'

Gem::Specification.new do |spec|
  spec.name          = 'ally'
  spec.version       = Ally::VERSION
  spec.authors       = ['Chad Barraford']
  spec.email         = ['cbarraford@gmail.com']
  spec.summary       = %q(A personal assistant)
  spec.description   = %q(Ally is a personal assistant, an ally that's got your back!)
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  # runtime dependencies
  %w( daemons thor stanford-core-nlp treat ).each do |gem|
    spec.add_dependency gem
  end

  # development dependencies
  spec.add_development_dependency 'bundler', '~> 1.5'
  %w( rake rubocop rspec ).each do |gem|
    spec.add_development_dependency gem
  end
end
