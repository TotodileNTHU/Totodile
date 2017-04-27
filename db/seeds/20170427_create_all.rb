Sequel.seed(:development) do
  def run 
    puts 'Seeding accounts, projects'
    create_accounts
    create_postings
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ALL_ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yaml")
ALL_POSTINGS_INFO = YAML.load_file("#{DIR}/postings_seed.yaml")

def create_accounts
  ALL_ACCOUNTS_INFO.each do |account_info|
  	CreateAccount.call(account_info.to_json)
  end
end

def create_postings
  ALL_POSTINGS_INFO.each do |posting_info|
  	data = {
  	  uid: posting_info[:uid],
      content: posting_info[:content]
  	}.to_json
  	CreatePosting.call(JSON.parse(data))
  end
end
