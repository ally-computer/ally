require 'yaml'

module Ally
  module Settings
    @settings = {}
    attr_reader :settings

    def self.load!(filename)
      config = YAML.load_file(filename)
      config.extend DeepSymbolizable
      @settings = config.deep_symbolize
    end
  end
end

# the following was borrowed from
# https://gist.github.com/morhekil/998709
module DeepSymbolizable
  def deep_symbolize(&block)
    method = self.class.to_s.downcase.to_sym
    syms = DeepSymbolizable::Symbolizers
    syms.respond_to?(method) ? syms.send(method, self, &block) : self
  end

  module Symbolizers
    # the primary method - symbolizes keys of the given hash,
    # preprocessing them with a block if one was given, and recursively
    # going into all nested enumerables
    def self.hash(hash, &block)
      hash.reduce({}) do |result, (key, value)|
        # Recursively deep-symbolize subhashes
        value = _recurse_(value, &block)

        # Pre-process the key with a block if it was given
        key = yield key if block_given?
        # Symbolize the key string if it responds to to_sym
        sym_key = key.to_sym rescue key

        # write it back into the result and return the updated hash
        result[sym_key] = value
        result
      end
    end

    # walking over arrays and symbolizing all nested elements
    def self.array(ary, &block)
      ary.map { |v| _recurse_(v, &block) }
    end

    # handling recursion - any Enumerable elements (except String)
    # is being extended with the module, and then symbolized
    def self._recurse_(value, &block)
      if value.is_a?(Enumerable) && !value.is_a?(String)
        # support for a use case without extended core Hash
        value.extend DeepSymbolizable unless value.class.include?(DeepSymbolizable)
        value = value.deep_symbolize(&block)
      end
      value
    end
  end
end
