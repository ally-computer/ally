module Ally
  class Inquiry
    attr_reader :raw

    require 'treat'
    require 'stanford-core-nlp'

    include Treat::Core::DSL

    def initialize(raw_text = nil)
      @raw = raw_text
    end

    def words_info
      if defined? @words_info
        @words_info
      else
        @words_info = []
        _sentence.each_word do |w|
          @words_info << { word: w.to_s, category: w.category.to_s }
        end
        @words_info
      end
    end

    def type_of(type)
      array = []
      case type.to_s
      when 'numbers'
        _sentence.each_number { |w| array << w.to_i }
      when 'words'
        _sentence.each_word { |w| array << w.to_s }
      when 'symbols'
        _sentence.each_symbol { |w| array << w.to_s }
      else
        return nil
      end
      array
    end

    # using _ ('underscore') to avoid method naming
    # conflict with Treat Core DSL
    def _sentence
      if defined? @sentence
        @sentence
      else
        if @raw.nil? || @length == 0
          @sentence = false
        else
          @sentence = sentence(@raw)
          @sentence.tokenize
          @sentence.apply(:parse)
        end
      end
    end

    def words_chomp_punc
      if defined? @words_chomp_punc
        @words_chomp_punc
      else
        @words_chomp_punc = words_with_punc.map do |word|
          word = word[1..-1] unless word[0] =~ /[0-9a-z$]/i
          word = word[0..-2] unless word[-1] =~ /[0-9a-z$]/i
          word
        end
      end
    end

    def words_with_punc
      if defined? @words_with_punc
        @words_with_punc
      else
        @words_with_punc = @raw.split(' ')
      end
    end

    def words
      if defined? @words
        @words
      else
        @words = @raw.gsub(/[^0-9a-z ]/i, '').split(' ')
      end
    end

    def length
      if defined? @length
        @length
      else
        @length = @raw.length
      end
    end

    def delete_words(list)
      list.each { |i| @words.delete(i) }
    end
  end
end
