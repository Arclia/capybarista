
module Capybarista

  class Session

    attr_reader :basis

    def initialize(capybara_session)
      @basis = capybara_session
    end

    def self.for(input)
      if input.is_a? Capybarista::Session
        return input
      else
        return Capybarista::Session.new input
      end
    end


    # Returns the list of inputs that require some form
    # of iteraction w/ the user.
    def all_fields(options = {})
      fields = @basis.all(:xpath, "//*[self::input | self::textarea | self::select][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'hidden' or ./@type='button')]", options)
    end


    def method_missing(name, *args, &block)
      @basis.public_send(name, *args, &block)
    end

  end


end
