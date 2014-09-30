# create render class
# this class takes input and renders a return text
module Ally
  module Render
    @all_keywords = nil

    attr_accessor :keywords
    attr_reader :plugin_settings, :user_settings

    def initialize
      @keywords = []
      @plugin_settings = Ally::Foundation.get_plugin_settings(self.class.to_s, 'renders') || {}
      @user_settings = Ally::Foundation.get_user_settings()
    end

    def self.descendants
      # load all ally render gems available
      gems = Bundler.load.specs.each do |s|
        if s.name =~ /^ally-render-/
          require s.name.gsub('-', '/')
        end
      end
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.keywords
      if @plugin_settings.key?(:keywords) && @plugin_settings[:keywords].class == Array
        @plugin_settings[:keywords] + @keywords
      else
        @keywords
      end
    end

    def self.render_keywords
      if @all_keywords.nil?
        keywords = {}
        Ally::Render.descendants.each do |c|
          my_class = c.new
          keywords[c.to_s] = { keywords: my_class.keywords, class_ref: c }
        end
        @all_keywords = keywords
      end
    end

    def self.get_render(inquiry)
      renders = []
      @all_keywords.each_value do |c|
        total = 0
        c[:keywords].each_with_index do |keyword, index|
          total += index + 1 if inquiry.words.include?(keyword)
        end
        renders << { total: total, class_ref: c[:class_ref] } unless total == 0
      end
      if renders.length == 0
        # if no render matches, default to Wolfram
        Ally::Render::Wolfram if defined?(Ally::Render::Wolfram)
      else
        my_render = renders.sort_by { |r| r[:total] }.first
        my_render[:class_ref]
      end
    end
  end
end
