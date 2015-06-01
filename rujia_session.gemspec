$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rujia_session/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rujia_session"
  s.version     = RujiaSession::VERSION
  s.authors     = ["hzh"]
  s.email       = ["sforce1000@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RujiaSession."
  s.description = "TODO: Description of RujiaSession."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
end
