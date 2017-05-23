# Find account and check password
class AuthenticateAccount
  def self.call(credentials)
    account = Account.first(name: credentials['name'])
    account&.password?(credentials['password']) ? account : nil
  end
end
