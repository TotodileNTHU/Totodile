# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'

require './init.rb'

include Rack::Test::Methods

def app
  TotodileAPI
end

SAD_ACCOUNT_UID = 'sad_user_uid'
SAD_POSTING_ID = '-1'
HAPPY_ACCOUNT_UID1 = 'leo'
HAPPY_ACCOUNT_UID2 = 'cory'
HAPPY_ACCOUNT_NAME1 = 'balaboom'
HAPPY_ACCOUNT_NAME2 = 'coryhasgirlfriend'
HAPPY_POSTING_CONTENT = 'lalala'
HAPPY_PASSWORD = '12345678'
HAPPY_EMAIL = 'test_email@gmail.com'