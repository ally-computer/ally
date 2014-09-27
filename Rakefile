#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task default: :spec
task setup: ['setup:bundle', 'setup:nlp']

namespace :setup do
  desc 'Bundle install'
  task :bundle do
    `bundle install`
  end
  # Installs a language pack (default to english).
  # A language pack is a set of gems, binaries and
  # model files that support the various workers
  # that are available for that particular language.
  # Syntax: rake treat:install (installs english)
  # - OR -  rake treast:install[some_language]
  desc 'Install NLP dependencies'
  task :nlp, [:language] do |_t, args|
    begin
      require 'treat'
      language = args.language || 'english'
      Treat::Core::Installer.install(language)
    rescue Gem::LoadError
      puts 'Must install other dependencies first (run `rake setup`)'
    end
  end
end
