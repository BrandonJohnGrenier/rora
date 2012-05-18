Gem::Specification.new do |s|
  s.name        = "rora"
  s.version     = "0.0.5"
  s.platform    = Gem::Platform::RUBY
  s.summary     = "A Ruby poker library"
  s.description = "A Ruby library for conducting poker experiments and simulations"

  s.author      = "Brandon John Grenier"
  s.email       = "brandon@moralesce.com"
  s.homepage    = "http://www.moralesce.com"
  
  s.files       = Dir.glob("{lib/**/*}") + %w{ LICENSE README.md Rakefile }
  s.test_files  = Dir.glob("{test/**/*}")

  s.add_runtime_dependency "rake", ">= 0.9.0"
  s.add_runtime_dependency "active_support", ">= 3.2.3"
  s.add_runtime_dependency "rspec-mocks", ">= 2.10.1"
end