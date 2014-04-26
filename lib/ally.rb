begin
  # look for local copy first for dev purposes
  require_relative '../lib/ally/version'
  require_relative '../lib/ally/cli'
  require_relative '../lib/ally/settings'
  require_relative '../lib/ally/foundation'
rescue LoadError
  require 'ally/version'
  require 'ally/cli'
  require 'ally/settings'
  require 'ally/foundation'
end

module Ally
end
