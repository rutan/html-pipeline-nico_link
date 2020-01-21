
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html/pipeline/nico_link/version'

Gem::Specification.new do |spec|
  spec.name          = 'html-pipeline-nico_link'
  spec.version       = HTML::Pipeline::NicoLink::VERSION
  spec.authors       = ['ru_shalm']
  spec.email         = ['ru_shalm@hazimu.com']
  spec.summary       = 'niconico link for html-pipeline'
  spec.homepage      = 'https://github.com/rutan/html-pipeline-nico_link/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'html-pipeline', '~> 2.4'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '0.79.0'
end
