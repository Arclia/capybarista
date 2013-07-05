Gem::Specification.new do |s|
  s.name        = 'capybarista'
  s.version     = '0.0.2'
  s.date        = '2013-07-02'
  s.summary     = "Useful extensions for Capybara"
  s.description = "Useful extensions for Capybara"
  s.authors     = ["Brian Lauber"]
  s.email       = 'blauber@jibe.com'
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"


  # TODO: We'll probably be fine w/ capybara 2.x as well
  s.add_dependency "capybara", "~> 1.1"

  s.add_dependency "logbert", "~> 0.6.4"
end

