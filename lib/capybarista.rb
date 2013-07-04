
require 'capybarista/extensions'

module Capybarista

  module Finders

    def all(*args)
      basis.all(*args).map{|f| Capybarista::Element.for(f) }
    end

    def find(*args)
      Capybarista::Element.for basis.find(*args)
    end

    def find_button(*args)
      Capybarista::Element.for basis.find_button(*args)
    end

    def find_by_id(*args)
      Capybarista::Element.for basis.find_by_id(*args)
    end

    def find_field(*args)
      Capybarista::Element.for basis.find_field(*args)
    end

    def find_link(*args)
      Capybarista::Element.for basis.find_link(*args)
    end

    def first(*args)
      Capybarista::Element.for basis.first(*args)
    end

  end



  class Session
    include Capybarista::Finders
    include Capybarista::Extensions::Session

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


    def within(input, *args, &block)
      input = Capybarista::Element.unwrap(input)
      @basis.within(input, *args, &block)
    end



    def method_missing(name, *args, &block)
      @basis.public_send(name, *args, &block)
    end

  end



  class Element
    include Capybarista::Finders
    include Capybarista::Extensions::Element

    attr_reader :basis, :session

    def initialize(element, session)
      @basis   = element
      @session = session
    end

    def self.for(input, session = nil)
      if input.is_a? Capybarista::Element
        return input
      else
        session ||= Capybarista::Session.new(input.session)
        return Capybarista::Element.new input
      end
    end


    def self.unwrap(input)
      while input.is_a? Capybarista::Element
        input = input.basis
      end
      input
    end



    def method_missing(name, *args, &block)
      @basis.public_send(name, *args, &block)
    end

  end


end
