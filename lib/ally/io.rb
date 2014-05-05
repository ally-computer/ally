module Ally
  module Io
    attr_accessor :settings

    def initialize
      @settings = Ally::Foundation.get_plugin_settings(self.class.to_s, 'ios') || {}
    end

    def input(inquiry, render = nil)
      if render.nil?
        r = Ally::Render.new
        r.render_keywords
        render = r.get_render(inquiry)
      end
      Ally::Foundation.new_chat(inquiry, render)
      render.new.process(inquiry, self)
      Ally::Foundation.end_chat
      Ally::Foundation.last_answer
    end

    def pass(text, render = nil)
      input(Ally::Inquiry.new(text), render)
    end

    def listen?
      self.respond_to?('listen')
    end

    def say(text)
      Ally::Foundation.add_answer(text)
    end
  end
end
