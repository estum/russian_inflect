# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'russian_inflect/version'

Gem::Specification.new do |spec|
  spec.name          = 'russian_inflect'
  spec.version       = RussianInflect::VERSION
  spec.authors       = ['Tõnis Simo']
  spec.email         = ['anton.estum@gmail.com']
  spec.description   = 'Склонение по падежам заголовков на русском языке'
  spec.summary       = 'Склоняет заданный заголовок по падежам'
  spec.homepage      = 'https://github.com/estum/russian_inflect'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'unicode_utils', '>= 1.4'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-power_assert'
  spec.add_development_dependency 'rubocop'
end
