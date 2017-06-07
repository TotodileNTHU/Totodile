Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, postings'
    create_accounts
    create_postings
    create_comments
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ALL_ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yaml")
ALL_POSTINGS_INFO = YAML.load_file("#{DIR}/postings_seed.yaml")
ALL_COMMENTS_INFO = YAML.load_file("#{DIR}/comments_seed.yaml")

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
    account = Account.find(uid: post_info[:uid])
    CreatePostingForOwner.call(owner_id: account.id, content: post_info[:content],
                               uid: post_info[:uid])
  end
end

def create_comments
  comment_info_each = ALL_COMMENTS_INFO.each
  loop do
    comment_info = comment_info_each.next
    postings = Posting.all
    postings.each do |posting|
      puts posting
      puts posting.owner
      CreateCommentForOwner.call(commenter_id: posting.owner.id, 
                                 content: comment_info[:content],
                                 posting_id: posting.id)
    end
  end
end
