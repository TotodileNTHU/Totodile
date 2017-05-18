# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Delete all database' do
  describe 'Clean the account and posting table' do
  	before do
      Account.dataset.destroy
      Posting.dataset.destroy
    end

    it 'HAPPY: database should be empty' do
      Account.count.must_equal 0
      Posting.count.must_equal 0    
    end
  end

end



    