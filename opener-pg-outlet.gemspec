require File.expand_path('../lib/opener/outlet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-pg-outlet'
  gem.version               = Opener::Outlet::VERSION
  gem.authors               = ['']
  gem.summary               = 'Database storing for the web services output when using callbacks.'
  gem.description           = gem.summary
  gem.homepage              = "https://github.com/chris-lu/opener-pg-outlet"
  gem.has_rdoc              = 'yard'
  gem.required_ruby_version = '>= 1.9.2'

  gem.license = 'Apache 2.0'

  gem.files = Dir.glob([
    'config/**/*',
    'lib/**/*',
    'config.ru',
    '*.gemspec',
    'README.md',
    'LICENSE.txt',
    'exec/**/*'
  ]).select { |file| File.file?(file) }

  gem.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'jdbc-postgres'
  gem.add_dependency 'activerecord-jdbcpostgresql-adapter'
  gem.add_dependency 'activerecord', '~> 3.0'
  gem.add_dependency 'safe_attributes'

  gem.add_dependency 'opener-daemons', '~> 2.2'
  gem.add_dependency 'opener-webservice', '~> 2.1'
  gem.add_dependency 'opener-core', '~> 2.2'

  gem.add_dependency 'opener-kaf2json'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end
