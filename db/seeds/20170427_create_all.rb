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

