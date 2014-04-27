require 'thor'

module Ally
  class Generate < Thor
    desc 'detector NAME', 'Generate ally detector scaffolding'
    def detector(name)
      Ally::Scaffold.new(name.downcase, 'detector')
    end

    desc 'render NAME', 'Generate ally render scaffolding'
    def render(name)
      Ally::Scaffold.new(name.downcase, 'render')
    end

    desc 'io NAME', 'Generate ally io scaffolding'
    def io(name)
      Ally::Scaffold.new(name.downcase, 'io')
    end

    desc 'task NAME', 'Generate ally task scaffolding'
    def task(name)
      Ally::Scaffold.new(name.downcase, 'task')
    end
  end

  class Cli < Thor
    package_name 'ally'

    class_option :config,
                 desc: 'configuration file',
                 aliases: '-c',
                 default: './ally.yml',
                 type: :string

    class_option :verbose,
                 type: :boolean,
                 default: false

    desc 'interactive', 'start ally in interactive mode'
    def interactive
      puts options
    end

    desc 'start', 'start ally in daemon mode'
    def start
      Ally::Settings.load!(options['config']) if options['config']
    end

    desc 'generate SUBCOMMAND', 'Generate an ally module scaffolding'
    subcommand 'generate', Generate
  end
end
