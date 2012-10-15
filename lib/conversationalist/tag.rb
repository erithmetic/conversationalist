require 'active_support/inflector'

module Conversationalist  
  class Tag
    attr_accessor :value, :type

		def initialize(type, value)
		  @type = type
			@value = value
		end
		
		# scan the given tokens and tag any matches
		def self.scan(tokens)
		  tokens.each do |token|
		    if t = self.scan_for_numbers(token) then token.tag(t) end
		    if t = self.scan_for_units(token) then token.tag(t) end
	    end
		  tokens
	  end
	  
	  # check the token to see if if it is a number
	  # then tag it
	  def self.scan_for_numbers(token)
	    if token.word =~ /(^|\W)(\d*\.\d+)($|\W)/ || token.word =~ /(^|\W)(\d+)($|\W)/
	      return Tag.new(:number, $2.to_f)
      end
      return nil
    end
    
    # check the token and see if it is a type of unit that Alchemist can handle
    # then tag the token with that unit type
    def self.scan_for_units(token)
      return nil if token.get_tag(:number)
      # all units
      word = token.word.downcase
      POSSIBLE_UNITS.each do |unit|
        if word.length<=2 # special matching for short forms ex. Mi
          return new(:unit, unit) if word == unit.to_s
        elsif word =~ /(^|\W)#{unit.to_s}($|\W)/i
          return new(:unit, unit)
        end
      end
      
      # try si units with prefixes (kilo, deca etc)
      #Alchemist.unit_prefixes.each do |prefix, value|
        #if token.word =~ /^#{prefix.to_s}.+/i
          #Alchemist.si_units.each do |unit|
            #if unit.to_s=~/#{token.word.gsub(/^#{prefix.to_s}/i,'')}$/i
              #return Tag.new(:unit, "#{prefix}#{unit}") 
            #end
          #end
        #end
      #end

      return nil
    end
    
    def to_s
      "#{type}-#{value}"
    end
  end
end
