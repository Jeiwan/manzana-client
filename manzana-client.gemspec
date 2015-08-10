Gem::Specification.new do |s|
  s.name        = 'manzana'
  s.version     = '0.0.1'
  s.license     = 'MIT'
  s.summary     = 'Client for Manzana API'
  s.description = 'Client for Manzana API'
  s.authors     = ['Ivan Kuznetsov']
  s.email       = 'me@jeiwan.ru'
  s.files       = Dir['lib/**/*.rb']
  s.test_files  = Dir['spec/**/*']
  #s.homepage    = 'https://rubygems.org/gems/example'
  
  s.add_runtime_dependency 'savon'
  s.add_development_dependency 'rspec', '~> 3.0.0'
end
