
require 'capybara'

module Capybarista

  module Extensions

    def self.apply!

      Capybara::Session.class_eval do
        include Capybarista::Extensions::Session
      end

      Capybara::Node::Element.class_eval do
        include Capybarista::Extensions::Element
      end

    end


    module Session

      # Returns the list of fields that require user input.
      def all_fields(options = {})
        all(:xpath, ".//*[self::input | self::textarea | self::select][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'hidden' or ./@type='button')]", options)
      end

    end



    module Element

      # Syntactic sugar.  Yum!
      def scoped
        s = session
        s.within(self){ yield s }
      end

    end

  end

end