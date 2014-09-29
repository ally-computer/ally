module Ally
  module Io
    attr_accessor :settings

    def initialize
      @plugin_settings = Ally::Foundation.get_plugin_settings(self.class.to_s, 'ios') || {}
      @user_settings = Ally::Foundation.get_user_settings()
    end

    def input(inquiry, render = nil)
      if render.nil?
        Ally::Render.render_keywords
        render = Ally::Render.get_render(inquiry)
      end
      Ally::Foundation.new_chat(inquiry, render)
      unless render.nil?
        render.new.process(inquiry, self)
        Ally::Foundation.end_chat
        Ally::Foundation.last_answer
      end
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
