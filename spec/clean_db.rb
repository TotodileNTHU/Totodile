# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Delete all database' do
  describe 'Clean the user and posting table' do
  	before do
      DB[:users].delete
      DB[:postings].delete
    end

    it 'HAPPY: database should be empty' do
      User.count.must_equal 0
      Posting.count.must_equal 0    
    end
  end

end



    