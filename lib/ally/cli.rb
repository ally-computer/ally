require 'rubygems'
require 'daemons'
require 'thor'
require 'ally'
require 'bundler'

module Ally
  class Generate < Thor
    desc 'detector NAME', 'Generate ally detector scaffolding'
    def detector(name)
      build_scaffold(name, 'detector')
    end

    desc 'render NAME', 'Generate ally render scaffolding'
    def render(name)
      build_scaffold(name, 'render')
    end

    desc 'io NAME', 'Generate ally io scaffolding'
    def io(name)
      build_scaffold(name, 'io')
    end

    desc 'task NAME', 'Generate ally task scaffolding'
    def task(name)
      build_scaffold(name, 'task')
    end

    no_tasks {
      def build_scaffold(name, type)
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
        # check if ally is already running
        if File.exist?(options[:pid])
          puts "An ally process is already running (PID #{File.read(options[:pid])})"
          exit 1
        else
          Ally::Settings.load!(options['config']) if options['config']
          Daemons.daemonize if options[:daemonize]
          # start app
          threads = []
          # require all ally io plugins
          Bundler.load.specs.each do |g|
            require g.name.gsub('-', '/') if g.name =~ /^ally-io-/
          end
          # get list of Io classes available to initailize listeners
          io_classes = Ally::Io.constants.collect{|k| Ally::Io.const_get(k)}.select {|k| k.is_a?(Class)}
          io_classes.each do |io_class|
            c = io_class.new
            threads << Thread.new{ start_io_listen(c) } if c.listen?
            threads.each {|t| t.join }
          end
        end
      end

      def stop_app(options)
        if File.exist?(options[:pid])
          pid = File.read(options[:pid])
          Process.kill("KILL", pid)
        else
          puts "Unable to find ally PID"
        end
      end
    }
  end
end
