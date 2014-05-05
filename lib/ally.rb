classes = %w(
  version cli settings foundation scaffold inquiry chat io render task detector
)

# look for local copy first for dev purposes
classes.each do |c|
  begin
    require_relative "../lib/ally/#{c}"
  rescue LoadError
    require "ally/#{c}"
  end
end

# load any ally plugin gems installed
require 'bundler'
gems = Bundler.load.specs.select do |s|
  s.name =~ /^ally-(io|render|task)-/
end
gems.each do |gem|
  require gem.name.gsub('-', '/') unless Gem.loaded_specs.keys.include?(gem.name)
end

module Ally
end
