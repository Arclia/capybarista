
module Capybarista

  class Capybarista

    attr_reader :session

    def initialize(capybara_session)
      @session = capybara_session
    end


    # Returns the list of inputs that require some form
    # of iteraction w/ the user.
    def all_fields
      fields = @session.all(:xpath, "//*[self::input | self::textarea | self::select][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'hidden' or ./@type='button')]")
    end

  end

end
