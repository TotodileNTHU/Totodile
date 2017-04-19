# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'

require './init.rb'
require './app.rb'

include Rack::Test::Methods

def app
  TotodileAPI
end

SAD_USER_UID = 'sad_user_uid'
SAD_POSTING_ID = '-1'
HAPPY_USER_UID1 = 'leo'
HAPPY_USER_UID2 = 'cory'
HAPPY_USER_NAME1 = 'balaboom'
HAPPY_USER_NAME2 = 'coryhasgirlfriend'
HAPPY_POSTING_CONTENT = 'lalala'