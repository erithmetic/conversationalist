module Conversationalist
  class Parser
    attr_accessor :text

    def initialize(text)
      self.text = text.dup
    end

    def parse
      puts "TEXT: #{text}" if Conversationalist.debug
      @tokens = self.tokenize(text).select { |token| token.tagged? }
      puts "TOKENS: #{@tokens}" if Conversationalist.debug
      
      return nil unless @tokens.length>1
      
      # at the moment all we handle is a number followed by a unit
      unit = nil
      last_number = nil
      result = nil
      @tokens.each do |token|
        if last_number && (unit=token.get_tag(:unit))
          unit = unit.value
          break
        elsif (num=token.get_tag(:number))
          last_number = num.value
        end
      end
      
      if Conversationalist.si_units.include?(unit)
        last_number
      else
        base = Conversationalist.base(unit)
        last_number.convert(unit, base)
      end
    end
    
    def tokenize(text)
      # cleanup the string before tokenizing
      text = normalize(text)
      @tokens = text.split(' ').collect { |word| Token.new(word) }
      @tokens = Tag.scan(@tokens)
    end
    
    def normalize(text)
      text = normalize_multiword(text)
      puts "MULTIWORDED: #{text}" if Conversationalist.debug
      return text
    end
    
    def normalize_multiword(text)
      MULTIWORD_UNITS.each do |unit|
        text = text.gsub(/#{unit.split('_').join(' ')}/i, unit)
      end
      text
    end
  end
end
