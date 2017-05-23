Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, postings'
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
  	CreateAccount.call(account_info)
  end
end

def create_postings
  post_info_each = ALL_POSTINGS_INFO.each
  accounts_cycle = Account.all.cycle
  loop do
    post_info = post_info_each.next
    account = accounts_cycle.next
    CreatePostingForOwner.call(owner_id: account.id, content: post_info[:content],
                               uid: post_info[:uid])
  end
end
