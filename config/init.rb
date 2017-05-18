# frozen_string_literal: true
require_relative 'environment'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end
