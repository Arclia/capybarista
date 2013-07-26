
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


    module Base

      # Returns the list of fields that require user input.
      def all_fields(options = {})
        all(:xpath, ".//*[self::input | self::textarea | self::select][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'hidden' or ./@type='button')]", options)
      end

    end


    module Session
      include Base

    end



    module Element
      include Base

      # Syntactic sugar.  Yum!
      def scoped
        s = session
        s.within(self){ yield s }
      end


      # Returns 0 or more labels for the current element
      def all_labels
        id = self[:id]
        if id
          query = Capybarista::Queries::XPath.labels_for_id(id)
          return session.all(:xpath, query)
        else
          return []
        end
      end


      def find_label
        id = self[:id]
        if id
          query = Capybarista::Queries::XPath.labels_for_id(id)
          return session.find(:xpath, query)
        else
          raise Capybara::ElementNotFound, "The element has no labels"
        end
      end

      def first_label
        id = self[:id]
        if id
          query = Capybarista::Queries::XPath.labels_for_id(id)
          return session.first(:xpath, query)
        else
          return nil
        end
      end

    end


  end

end