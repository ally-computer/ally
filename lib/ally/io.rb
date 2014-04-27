module Ally
  class IO
    attr_accessor :settings

    def initialize
      @settings = nil
      if self.class.to_s =~ /^Ally::IO::/
        class_name = self.class.to_s.split('::').last
        if Ally::Settings.settings[:io] && Ally::Settings.settings[:io][class_name.downcase.to_sym]
          @settings = Ally::Settings.settings[:io][class_name.downcase.to_sym]
        end
      end
      init if self.respond_to?('init')
    end

    def input(inquiry, render=nil)
      if render.nil?
        r = Ally::Render.new
        r.render_keywords
        render = r.get_render(inquiry)
      end
      Ally::Settings.new_chat(inquiry, render)
      render.new.process(inquiry, self)
      Ally::Settings.end_chat
      Ally::Settings.last_answer
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
