classes = %w(
  version cli settings foundation scaffold
)

# look for local copy first for dev purposes
classes.each do |c|
  begin
    require_relative "../lib/ally/#{c}"
  rescue LoadError
    require "ally/#{c}"
  end
end

module Ally
end
