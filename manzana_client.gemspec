Gem::Specification.new do |s|
  s.name        = 'manzana_client'
  s.version     = '1.0.0'
  s.license     = 'MIT'
  s.summary     = 'Client for Manzana API'
  s.description = 'Client for Manzana API'
  s.authors     = ['Ivan Kuznetsov']
  s.email       = 'me@jeiwan.ru'
  s.files       = Dir['lib/**/*.rb']
  s.test_files  = Dir['spec/**/*']
  s.homepage    = 'https://github.com/Jeiwan/manzana-client'
  
  s.add_runtime_dependency 'savon'
  s.add_development_dependency 'rspec', '~> 3.0.0'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
end
