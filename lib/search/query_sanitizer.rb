module Search
  module QuerySanitizer
    extend self

    def sanitize(string)
      replace_punctuation(string)
      replace_reserved_keywords(string)
      string.squish
    end

    def replace_punctuation(string)
      punctuation = '([\~:\-\\\/\!\.,\|])'
      string.gsub!(/(^|\s)#{punctuation}+|#{punctuation}+(\s|$)/, ' ')
    end

    def replace_reserved_keywords(string)
      string.gsub!(/(\s|^)(AND|OR|NOT)(\s|$)/i, ' ')
    end
  end
end
