require File.expand_path('../lib/opener/outlet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-outlet'
  gem.version               = Opener::Outlet::VERSION
  gem.authors               = ['development@olery.com']
  gem.summary               = 'SQLite3 data storing for the web services output when using callbacks.'
  gem.description           = gem.summary
  gem.homepage              = "http://opener-project.github.com/"
  gem.has_rdoc              = 'yard'
  gem.required_ruby_version = '>= 1.9.2'

  gem.files       = `git ls-files`.split("\n")
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'builder', '~>3.0.0'
  gem.add_dependency 'sinatra', '~>1.4.2'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'uuidtools'
  gem.add_dependency 'jdbc-mysql'
  gem.add_dependency 'activerecord-jdbcmysql-adapter'
  gem.add_dependency 'activerecord', '~>3.2.0'
  gem.add_dependency 'activesupport', '~>3.2.0'
  gem.add_dependency 'opener-webservice'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end
