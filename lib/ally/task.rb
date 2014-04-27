module Ally
  class Task
    attr_accessor :io, :wait, :infinite_loop
    attr_reader :thread

    def initialize
      @infinite_loop = false
      @interval = 10
      @io = nil
      @thread = nil
      @settings = Ally::Settings.get_plugin_settings(self.class.to_s, 'Task')
    end

    def run(io, wait = false, **options)
      @io = io
      @thread = Thread.new do
        count = 0
        begin
          sleep @interval unless count == 0
          self.run_task(options)
          count += 1
        end while @infinite_loop == true
      end
      @thread.join if wait == true
    end

    def end_task(nicely=true)
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
