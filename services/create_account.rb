# Service object to create new accounts using all columns
class CreateAccount
  def self.call(registration)
    account = Account.new(
        uid: registration[:uid], name: registration[:name], email: registration[:email]
    )
    account.password = registration[:password]
    account.save
  end
end
