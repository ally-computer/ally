require 'thor'

module Ally
  class Cli < Thor
    package_name 'ally'

    class_option  :config,
                  desc: 'configuration file',
                  aliases: '-c',
                  default: './ally.yml',
                  type: :string
      
    class_option  :verbose,
                  type: :boolean,
                  default: false

    desc 'interactive', 'start ally in interactive mode'
    def interactive
      puts options
    end

    desc 'start', 'start ally in daemon mode'
    def start
      if options['config']
        Ally::Settings.load!(options['config'])
      end
    end
  end
end
