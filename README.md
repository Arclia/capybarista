Capybarista
=========================

It's like Capybara on Caffeine!


Usage
-------------------------

    require 'capybara'
    require 'capybarista'

    # Monkey-patch Capybara and enable extensions
    Capybarista::Extensions.apply!

    s = Capybara::Session.new :selenium
    s.visit "http://www.kernel.org"


    # For each link in the header...
    s.all(:css, "header a").each do |e|
      puts "Inner HTML:"
      puts e.inner_html
      puts

      puts "Outer HTML:"
      puts e.outer_html
      puts

      puts "-" * 40

      e.highlight
      sleep 1
    end


TODO
-------------------------

* Make it easier to use Capybarista without monkey-patching Capybara
* Refine the unique_xpath method so ensure that it is using proper encoding
* Cleanup the Javascript methods.

