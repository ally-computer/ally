module Ally
  class Foundation
    attr_accessor :chats

    def get_plugin_settings(class_name, class_type)
      if Ally::Settings.settings[class_type.to_sym] && Ally::Settings.settings[class_type.to_sym][class_name.downcase.to_sym]
        Ally::Settings.settings[class_type.to_sym][class_name.downcase.to_sym]
      end
    end

    def new_chat(inquiry, render)
      @current_chat = Ally::Chat.new(inquiry, render)
    end

    def add_answer(text)
      @current_chat.answer(text) unless @current_chat.nil?
    end

    def end_chat
      @chats << @current_chat rescue @chats = [@current_chat]
      # keep the last 1000 chats
      @chats = @chats[-1000..-1] if @chats.length > 1000
      @current_chat = nil
    end

    def last_chat
      @chats.last
    end
    
    def last_answer
      @chats.last.answers.last
    end
  end
end
