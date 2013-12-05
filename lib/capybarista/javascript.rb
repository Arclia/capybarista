

module Capybarista
  module Javascript

    # Generates a fragment of Javascript that will evaluate the
    # specified XPath query.
    def find_xpath(query)
      %Q{document.evaluate("#{query}", document, null, XPathResult.ANY_TYPE, null ).iterateNext()}
    end

    module_function :find_xpath




  end
end

