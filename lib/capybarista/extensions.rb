
require 'capybara'

require 'capybarista/queries'

require 'logbert'

module Capybarista

  module Extensions
    LOG = Logbert[self]


    def self.applied?
      @applied
    end

    def self.apply!

      if applied?
        LOG.debug "Capybarista extensions have already been applied"
      else
        Capybara::Session.class_eval do
          include Capybarista::Extensions::Session
        end

        Capybara::Node::Element.class_eval do
          include Capybarista::Extensions::Element
        end

        @applied = true
        LOG.warning "Capybara::Session and Capybara::Node::Element have been monkey-patched w/ the Capybarista extensions"
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


      # Returns 0 or more labels for the current element
      def all_labels
        id = self[:id]
        id ? session.all(:xpath, "//label[@for='#{id}']") : []        
      end

      # Returns the first label for the current element, or
      # nil if no label exists
      def find_label
        labels.first
      end

    end


  end

end