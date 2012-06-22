# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'db_nazi/version'

Gem::Specification.new do |gem|
  gem.name          = 'db_nazi'
  gem.version       = DBNazi::VERSION
  gem.authors       = ['George Ogata']
  gem.email         = ['george.ogata@gmail.com']
  gem.license       = 'MIT'
  gem.description   = "TODO: Write a gem description"
  gem.summary       = "TODO: Write a gem summary"
  gem.homepage      = ''

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_development_dependency 'ritual', '~> 0.4.1'
  gem.add_development_dependency 'temporaries', '~> 0.2.0'
  gem.add_development_dependency 'looksee', '~> 0.2.0'
end
