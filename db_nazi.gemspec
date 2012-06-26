# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'db_nazi/version'

Gem::Specification.new do |gem|
  gem.name          = 'db_nazi'
  gem.version       = DBNazi::VERSION
  gem.authors       = ['George Ogata']
  gem.email         = ['george.ogata@gmail.com']
  gem.license       = 'MIT'
  gem.description   = ""
  gem.summary       = "Encourage good DB practices in ActiveRecord migrations."
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_runtime_dependency 'activerecord', '~> 3.2.6'
  gem.add_development_dependency 'ritual', '~> 0.4.1'
  gem.add_development_dependency 'minitest', '~> 3.1.0'
  gem.add_development_dependency 'temporaries', '~> 0.3.0'
  gem.add_development_dependency 'sqlite3', '~> 1.3.6'
end
