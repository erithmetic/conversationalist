module Conversationalist
  # based on the Token class found in Chronic
  class Token
     attr_accessor :word, :tags

    def initialize(word)
      @word = word
      @tags = []
    end

    # Tag this token with the specified tag
    def tag(new_tag)
      @tags << new_tag
    end

    # Remove all tags of the given class
    def untag(tag_type)
      @tags = @tags.select { |m| m.type!=tag_type }
    end

    # Return true if this token has any tags
    def tagged?
      @tags.size > 0
    end

    # Return the Tag that matches the given class
    def get_tag(tag_type)
      matches = @tags.select { |m| m.type==tag_type }
      return matches.first
    end

    # Print this Token in a pretty way
    def to_s
      "#{@word}(#{@tags.join(', ')})"
    end
  end
end
