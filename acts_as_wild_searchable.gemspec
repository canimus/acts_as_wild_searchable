$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_wild_searchable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_wild_searchable"
  s.version     = ActsAsWildSearchable::VERSION
  s.authors     = ["Herminio Vazquez"]
  s.email       = ["canimus@gmail.com"]
  s.homepage    = "http://www.canimus.com"
  s.summary     = "Extends your models to use the :attr_like? method to use wild cards"
  s.description = "This gem allows you to use the acts_as_wild_searchable tag to your models and make methods for each attribute to search using wild cards and like"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"

  s.add_development_dependency "sqlite3"
end
