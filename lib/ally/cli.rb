require 'rubygems'
require 'daemons'
require 'thor'

module Ally
  class Generate < Thor
    desc 'detector NAME', 'Generate ally detector scaffolding'
    def detector(name)
      build_scaffold('detector')
    end

    desc 'render NAME', 'Generate ally render scaffolding'
    def render(name)
      build_scaffold('render')
    end

    desc 'io NAME', 'Generate ally io scaffolding'
    def io(name)
      build_scaffold('io')
    end

    desc 'task NAME', 'Generate ally task scaffolding'
    def task(name)
      build_scaffold('task')
    end

    no_tasks {
      def build_scaffold(type)
        Ally::Scaffold.new(name.downcase, type)
      end
    }
  end

  class Cli < Thor
    package_name 'ally'

    desc 'start', 'start ally'
    method_option :daemonize,
                  desc: 'run ally as a daemon',
                  aliases: '-d',
                  default: false,
                  type: :boolean
    method_option :config,
                  desc: 'configuration file',
                  aliases: '-c',
                  default: './ally.yml',
                  type: :string
    method_option :pid,
                  desc: 'pid file',
                  aliases: '-p',
                  default: '/var/run/ally.pid',
                  type: :string
    def start
      start_app(options)
    end

    desc 'stop', 'stop ally'
    method_option :pid,
                  desc: 'pid file',
                  aliases: '-p',
                  default: '/var/run/ally.pid',
                  type: :string
    def stop
      stop_app(options)
    end

    desc 'generate SUBCOMMAND', 'Generate an ally module scaffolding'
    subcommand 'generate', Generate

    no_tasks {
      def start_io_listen(io_class)
        sleep_delay = io_class.settings[:listen_delay] if io_class.settings[:listen_delay] &&
          io_class.settings[:listen_delay].class == Fixnum
        sleep_delay ||= 10
        loop do
          io_class.listen
          sleep sleep_delay
        end
      end

      def start_app(options)
        require 'ally'
        # check if ally is already running
        if File.exist?(options[:pid])
          puts "An ally process is already running (PID #{File.read(options[:pid])})"
          exit 1
        else
          Ally::Settings.load!(options['config']) if options['config']
          Daemons.daemonize if options[:daemonize]
          # start app
          threads = []
          # get list of Io classes available to initailize listeners
          io_classes = Ally::Io.constants.collect{|k| Ally::Io.const_get(k)}.select {|k| k.is_a?(Class)}
          puts io_classes
          io_classes.each do |io_class_name|
            puts io_class_name
            io_class = io_class_name.split('::').inject(Object) {|o,c| o.const_get c}
            threads << Thread.new{ start_io_listen(io_class) } if io_class.listen?
            theads.each {|t| t.join }
          end
        end
      end

      def stop_app(options)
      end
    }
  end
end
