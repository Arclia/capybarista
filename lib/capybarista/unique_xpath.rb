
module Capybarista

  module UniqueXPath

    class UniquenessError < StandardError
    end

    def self.for(element)
      session   = element.session

      fragments = []
      loop do
        fragments.unshift fragment(element)

        query = "//" + fragments.join("/")

        occurrences = session.all(:xpath, query).count
        if occurrences == 1
          return query
        elsif occurrences == 0
          raise UniquenessError, "Failed to produce a unique xpath for the element"
        end

        element = element.find(:xpath, "..")
      end
    end


    def self.fragment(element)
      tag = element.tag_name
      id  = element[:id]

      if id.nil? or id.empty?
        index = element.all(:xpath, "preceding-sibling::#{ tag }").count + 1
        "#{tag}[#{index}]"
      else
        "#{tag}[@id='#{id}']"
      end
    end


  end

end

