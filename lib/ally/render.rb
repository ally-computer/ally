# create render class
# this class takes input and renders a return text
module Ally
  class Render
    @all_keywords = nil

    attr_accessor :settings, :keywords

    def initialize
      @keywords = []
      @settings = nil
      if self.class.to_s =~ /^Ally::Render::/
        class_name = self.class.to_s.split('::').last
        if Ally::Settings.settings[:renders] && Ally::Settings.settings[:renders][class_name.downcase.to_sym]
          @settings = Ally::Settings.settings[:renders][class_name.downcase.to_sym]
        end
      end
      init if self.respond_to?('init')
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def keywords
      if @settings.class == Hash && @settings.key?(:keywords) && @settings[:keywords].class == Array
        @settings[:keywords] + @keywords
      else
        @keywords
      end
    end

    def render_keywords
      if @all_keywords.nil?
        keywords = {}
        Ally::Render.descendants.each do |c|
          my_class = c.new
          keywords[c.to_s] = { keywords: my_class.keywords, class_ref: c }
        end
        @all_keywords = keywords
      end
    end

    def get_render(inquiry)
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
        Ally::Render::Wolfram
      else
        my_render = renders.sort_by { |r| r[:total] }.first
        my_render[:class_ref]
      end
    end
  end
end
