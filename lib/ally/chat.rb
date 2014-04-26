module Ally
  class Chat
    attr_accessor :inquiry, :render, :answers

    def initialize(inquiry, render)
      @inquiry = inquiry
      @render = render
      @answers = []
    end

    def answer(answer)
      @answers << answer
    end
  end
end
