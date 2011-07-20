Gem::Specification.new do |s|
  s.name = "couch_visible"
  s.summary = "Is a document visible?"
  s.version = File.read "VERSION"
  s.authors = "Matt Parker"
  s.email = "moonmaster9000@gmail.com"
  s.homepage = "http://github.com/moonmaster9000/couch_visible"
  s.description = "Specify whether or not a document is visible."
  s.add_development_dependency "cucumber"
  s.add_development_dependency "rspec"
  s.add_development_dependency "couchrest_model_config"
  s.add_development_dependency "memories"
  s.add_dependency "couchrest_model", "~> 1.0.0"
  s.files = Dir["lib/**/*"] << "VERSION" << "readme.markdown"
  s.test_files = Dir["features/**/*"]
end
