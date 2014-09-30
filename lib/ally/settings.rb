require 'yaml'

module Ally
  module Settings
    attr_accessor :settings

    def self.load_env_vars()
      @settings ||= {}
      # load settings from environment variables (do not override)
      ENV.each_pair do |k,v|
        if k =~ /ALLY_SETTINGS_/
          setting = k.downcase.split('_')[2..-1]
          # convert array => hash
          setting = setting.reverse.inject(v) { |a, n| { n => a } }
          # deep merge the setting into the config hash
          @settings = setting.deep_merge(@settings)
        end
      end
      @settings = Ally::Foundation.deep_symbolize(@settings)
    end

    def self.load!(file)
      @settings ||= {}
      config = YAML.load_file(file)
      config = config.deep_merge(@settings)
      @settings = Ally::Foundation.deep_symbolize(config)
    end

    def self.method_missing(name, *args, &block)
      self.load_env_vars() unless defined?(@settings)  # load environment vars (if havent)
      settings = @settings[name.to_sym] || {}
    end
  end
end

class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end
