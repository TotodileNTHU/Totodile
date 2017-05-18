# frozen_string_literal: true
require 'json'
require 'sequel'

require_relative 'account'
require_relative 'posting'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end
