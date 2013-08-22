
require 'xpath'

module Capybarista

  # This module contains a number of functions
  # for generating XPath and CSS queries
  module Queries

    module XPath


      def self.string(value)
        # The underlying API changes betw/ versions
        # 0.1.4 and 2.0.0 .  So, let's wrap the method.
        ::XPath::Expression::StringLiteral.new(value.to_s).to_xpath
      end


      # Queries returns all fields that accept user input
      def self.all_fields
        ".//*[self::input | self::textarea | self::select][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'hidden' or ./@type='button')]"
      end

      def self.labels_for(*ids)
        condition = ids.map{|id| "@for=#{string(id)}" }.join(" or ")
        "//label[#{condition}]"
      end

    end

  end

end

