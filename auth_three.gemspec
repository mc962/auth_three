$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth_three/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auth_three"
  s.version     = AuthThree::VERSION
  s.authors     = ["Michael Chilton"]
  s.email       = ["michaelc962@yahoo.com"]
  s.homepage    = "https://github.com/mc962/auth_three"
  s.summary     = "Automation for a basic authentication pattern"
  s.description = "Automate basic authentication for your coding challenges"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
  s.add_development_dependency "byebug"
  s.add_development_dependency "pry"
end
