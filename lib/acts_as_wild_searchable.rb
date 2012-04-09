# This module extends the capabilities
# of a rails model class exnteded of ActiveRecord::Base
# to allow searching on each of its attributes
# using a percentage wild card based on an
# array of options which can include 2 different types
# of entries: Strings and Hashes
# * Strings: will be used as search conditions
# * Hashes: will be only taken if they match: clause, left or right and their respective values are true
#
# Author::    Herminio Vazquez  (mailto:canimus@gmail.com)
# Copyright:: Copyright (c) 2012 Perforchestor
# License::   Distributes under the same terms as Ruby

# This module extends the capabilities to 
# perform queries in a rails model
# by implementing the method missing on the class
# and allowing the usage of _like? on every attribute
# and the side of the wild card for searching
module ActsAsWildSearchable
  extend ActiveSupport::Concern
  
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_wild_searchable(options={})
      # Code definition for search capabilities here
    end    
    
    def method_missing(method_name, *args)
      # Verify that method start with attribute name followed by like?
      if match = method_name.to_s.match(/^([a-zA-Z]\w*)_like\?$/)
        apply_filter(match.captures.first, args)
      else
        super
      end
    end
    
    private 

    # This method contains all the logic of the plugin
    # as it recognizes the parameters sent to the method
    # and executes the query in the model class
    # bold: Returns an ActiveRecord::Relation
    # Which means that can be chainable with other ActiveRecord::Relations
    def apply_filter(capture, filter)
      
      clauses = filter.select { |element| 
        element.kind_of? Hash 
      }.reduce({:clause=>"or"}) { |h, pairs| pairs.each { |k,v| h[k]=v}; h}
      
      conditions = filter.select { |element| 
        element.kind_of? String
      }.map { |condition| 
          wild_condition = "#{condition}"
          if (clauses.has_key?(:left) and clauses[:left]) 
            wild_condition.insert(0, "%")
          end

          if (clauses.has_key?(:right) and clauses[:right]) 
            wild_condition<<"%"
          end

          unless (wild_condition.start_with?("%") or wild_condition.end_with?("%"))
            wild_condition = "%#{condition}%"
          end

          wild_condition
      }         
      
        sentences = conditions.map { |x| "#{capture} like ?" }
      
      if (clauses.has_key?(:clause) and clauses[:clause]=="and" )
        join_type = " and "
      else
        join_type = " or "
      end
      sentences = sentences.join(join_type) if sentences.size > 1
      sentences = sentences.first if sentences.size == 1      
      where conditions.prepend sentences
    end
    
  end
  
  ActiveRecord::Base.send :include, ActsAsWildSearchable
end
