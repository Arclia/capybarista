Gem::Specification.new do |s|
  s.name        = 'capybarista'
  s.version     = '0.0.1'
  s.date        = '2013-07-02'
  s.summary     = "Generic finder queries for capybara"
  s.description = "Generic finder queries for capybara"
  s.authors     = ["Brian Lauber"]
  s.email       = 'blauber@jibe.com'
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"


  # TODO: We'll probably be fine w/ capybara 2.x as well
  s.add_dependency "capybara", "~> 1.1"
end

