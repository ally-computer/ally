# many thanks the speakmy.name for this code
# http://speakmy.name/2011/05/29/simple-configuration-for-ruby-apps/

module Ally
  class Settings
    extend self

    @_settings = {}
    attr_reader :_settings

    def load!(filename, options = {})
      newsets = YAML.load_file(filename).deep_symbolize
      newsets = newsets[options[:env].to_sym] if \
                                                 options[:env] && \
                                                 newsets[options[:env].to_sym]
      deep_merge!(@_settings, newsets)
    end

    # Deep merging of hashes
    # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
    def deep_merge!(target, data)
      merger = proc do |_key, v1, v2|
        Hash == v1.class && Hash == v2.class ? v1.merge(v2, &merger) : v2
      end
      target.merge! data, &merger
    end

    def method_missing(name, _args, _block)
      @_settings[name.to_sym] ||
      fail(NoMethodError, "unknown configuration root #{name}", caller)
    end
  end
end
