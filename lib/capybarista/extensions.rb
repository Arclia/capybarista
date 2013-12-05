
require 'capybara'

require 'capybarista/queries'
require 'capybarista/unique_xpath'
require 'capybarista/javascript'

require 'logbert'

module Capybarista

  module Extensions
    LOG = Logbert[self]

    J = Capybarista::Javascript

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
        all(:xpath, Capybarista::Queries::XPath.all_fields, options)
      end

    end


    module Session
      include Base

      #this method returns a list of labels that are sorted from bottom up, right to left
      def new_label_list
        fields = all_fields(visible:true).map{|f| {f: f, pos: f.top_left}  }
        list_of_lists = fields.map{ |i| i[:pos] }
        sorted_list = list_of_lists.sort {|item1, item2| item2[1]<=>item1[1]}
        labels_list = Array.new
        sorted_list.each do |item|
          label = fields.find { |h| h[:pos] == item }[:f]
          labels_list.push(label)    
        end
        labels_list
      end
    end


    module Element
      include Base

      # Syntactic sugar.  Yum!
      def scoped
        s = session
        s.within(self){ yield s }
      end

      # Returns a map containing only the specified attributes.
      # If the element does not contain an attribute, then its
      # key/value pairing will be omitted.
      #
      # FIXME: This methods filters attributes that are equal
      #        to the empty string :-(
      def filtered_attributes(*keys)
        retval = {}

        keys.each do |k|
          value = self[k]
          if value and not value.empty?
            retval[k] = value
          end
        end

        return retval
      end

      # Returns 0 or more labels for the current element
      def labels
        ids = filtered_attributes(:id, :name).values

        if ids.any?
          query = Capybarista::Queries::XPath.labels_for(*ids)
          return session.all(:xpath, query)
        else
          return []
        end
      end


      # Attempts to find the label for the current element.
      # If no label exists, then raise Capybara::ElementNotFound
      def label!
        ids = filtered_attributes(:id, :name).values

        if ids.any?
          query = Capybarista::Queries::XPath.labels_for(*ids)
          return session.find(:xpath, query)
        else
          raise Capybara::ElementNotFound, "The element has no labels"
        end
      end


      # Attempts to find the label for the current element.
      # If no label exists, then return nil.
      def label
        ids = filtered_attributes(:id, :name).values
        if ids.any?
          query = Capybarista::Queries::XPath.labels_for(*ids)
          return session.first(:xpath, query)
        else
          return nil
        end
      end

      def top_left
        long_function = %Q{
          (
            function(){
              var obj = document.evaluate("#{unique_xpath}", document, null, XPathResult.ANY_TYPE, null ).iterateNext(); 
                if(obj) { 
                
                  var curleft = 0; var curtop = 0;
                  if (obj && obj.offsetParent) {
                    do {
                        curleft += obj.offsetLeft;
                        curtop += obj.offsetTop;
                    } while (obj = obj.offsetParent);
                  }
                  return [curleft,curtop];
                };
            }()
          );
       }
        long_string = long_function.delete("\n")
        session.evaluate_script(long_string)
      end



      def unique_xpath
        Capybarista::UniqueXPath.for(self)
      end

      def inner_html
        session.evaluate_script %Q{(function(){ var result = #{ J.find_xpath(unique_xpath) }; if(result) { return result.innerHTML; } }()); }
      end


      def outer_html
        session.evaluate_script %Q{(function(){ var result = #{ J.find_xpath(unique_xpath) }; if(result) { return result.outerHTML; } }()); }
      end


      def highlight
        session.execute_script %Q{(function(){ var result = #{ J.find_xpath(unique_xpath) }; if(result) { var old_color = result.style.backgroundColor; result.style.backgroundColor = "yellow"; setTimeout(function(){ result.style.backgroundColor = old_color; }, 1000); } }()); }
      end


      def blur
        script = %Q{ (function() { var target = #{ J.find_xpath(unique_xpath) }; if(target) { var evt = document.createEvent("MouseEvents"); evt.initMouseEvent("blur", true, true,window, 1, 1, 1, 1, 1, false, false, false, false, 0, target); target.dispatchEvent(evt); } })(); }
        session.execute_script(script)
      end


      def focus
        script = %Q{ (function() { var target = #{ J.find_xpath(unique_xpath) }; if(target) { var evt = document.createEvent("MouseEvents"); evt.initMouseEvent("focus", true, true,window, 1, 1, 1, 1, 1, false, false, false, false, 0, target); target.dispatchEvent(evt); } })(); }
        session.execute_script(script)
      end


    end


  end

end