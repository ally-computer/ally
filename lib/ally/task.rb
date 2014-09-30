module Ally
  module Task
    attr_accessor :io, :wait, :infinite_loop
    attr_reader :thread, :plugin_settings, :user_settings

    def initialize
      @infinite_loop = false
      @interval = 10
      @io = nil
      @thread = nil
      @plugin_settings = Ally::Foundation.get_plugin_settings(self.class.to_s, 'tasks') || {}
      @user_settings = Ally::Foundation.get_user_settings()
    end

    def run(io, wait = false, **options)
      @io = io
      @thread = Thread.new do
        count = 0
        loop do
          sleep @interval unless count == 0
          run_task(options)
          count += 1
          break unless @infinite_loop
        end
      end
      @thread.join if wait == true
    end

    def end_task(nicely = true)
      if nicely
        @infinite_loop = false
      else
        @thread.kill
      end
    end

    def alive?
      @thread.alive?
    end
  end
end
