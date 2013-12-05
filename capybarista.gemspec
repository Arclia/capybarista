Gem::Specification.new do |s|
  s.name        = 'capybarista'
  s.version     = '0.1.2'
  s.date        = '2013-07-02'
  s.summary     = "Useful extensions for Capybara"
  s.description = "Useful extensions for Capybara"
  s.authors     = ["Brian Lauber"]
  s.email       = 'blauber@jibe.com'
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"


  # TODO: Someday, we should add support for Capybara 2.x
  s.add_dependency "capybara", "~> 1.1"
  s.add_dependency "xpath", "~> 0.1.4"

  s.add_dependency "logbert", "~> 0.6.4"
end

