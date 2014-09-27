module Ally
  module Foundation
    attr_accessor :chats

    def self.get_plugin_settings(class_name, class_type)
      Ally::Settings.send(class_type.to_sym)[class_name.split(/::/).last.downcase.to_sym]
    end

    def self.new_chat(inquiry, render)
      @current_chat = Ally::Chat.new(inquiry, render)
    end

    def self.add_answer(text)
      @current_chat.answer(text) unless @current_chat.nil?
    end

    def self.end_chat
      @chats << @current_chat rescue @chats = [@current_chat]
      # keep the last 1000 chats
      @chats = @chats[-1000..-1] if @chats.length > 1000
      @current_chat = nil
    end

    def self.last_chat
      @chats.last
    end

    def self.last_answer
      @chats.last.answers.last
    end
  end
end
