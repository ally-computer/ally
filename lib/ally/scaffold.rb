require 'erb'
require 'fileutils'

module Ally
  class Scaffold
    attr_accessor :config

    def initialize(name = nil, type = nil)
      @config = { git: {}, app: {} }
      git_name = `git config user.name`.chomp
      git_email = `git config user.email`.chomp
      @config[:git][:name] = git_name.empty? ? 'TODO: Write your name' : git_name
      @config[:git][:email] = git_email.empty? ? 'TODO: Write your email address' : git_email
      @config[:app][:type] = type
      @config[:app][:name] = name
      @config[:app][:description] = 'TODO: Write your description'
      @config[:app][:summary] = 'TODO: Write your summary'
      build_gem
    end

    def build_gem
      source_dir = File.dirname(__FILE__) + '/scaffold'
      target_dir = @config[:app][:name]
      FileUtils.mkdir(target_dir) unless Dir.exist?(target_dir)
      # create Gemfile
      copy_file("#{source_dir}/Gemfile.erb", "#{target_dir}/Gemfile", true)
      copy_file("#{source_dir}/new_gem.gemspec.erb", "#{target_dir}/#{@config[:app][:name]}.gemspec", true)
      copy_file("#{source_dir}/LICENSE", "#{target_dir}/LICENSE", false)
      copy_file("#{source_dir}/Rakefile", "#{target_dir}/Rakefile", false)
      copy_file("#{source_dir}/gitignore", "#{target_dir}/.gitignore", false)
      copy_file("#{source_dir}/rubocop.yml", "#{target_dir}/.rubocop.yml", false)
      copy_file("#{source_dir}/rspec", "#{target_dir}/.rspec", false)
      copy_file(
        "#{source_dir}/version.rb.erb",
        "#{target_dir}/lib/ally/#{@config[:app][:type]}/#{@config[:app][:name]}/version.rb",
        true
      )
      copy_file(
        "#{source_dir}/new_gem.rb.erb",
        "#{target_dir}/lib/ally/#{@config[:app][:type]}/#{@config[:app][:name]}.rb",
        true
      )
    end

    def copy_file(source, target, erb = false)
      if !File.exist?(target)
        FileUtils.mkdir_p(File.dirname(target))
        if erb == true
          template_file = File.open(source, 'r').read
          erb = ERB.new(template_file)
          File.open(target, 'w+') do |f|
            f.write(erb.result(binding))
          end
        else
          FileUtils.cp(source, target)
        end
        puts "[created] #{target}"
      else
        puts "[skipped] #{target}: File already exists"
      end
    end
  end
end
