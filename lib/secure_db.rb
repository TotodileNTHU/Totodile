require 'econfig'
require 'base64'
require 'rbnacl/libsodium'
require_relative 'securable'

class SecureDB < Sinatra::Base

  #inculde method:generate_key,setup,key,base_encrypt,base_decrypt
  extend Securable
  extend Econfig::Shortcut
  Econfig.env = settings.environment.to_s
  Econfig.root = File.expand_path('..', settings.root)

  # Encrypt or else return nil if data is nil
  def self.encrypt(plaintext)
    return nil unless plaintext
    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    ciphertext = simple_box.encrypt(plaintext)
    Base64.strict_encode64(ciphertext)
  end

  # Decrypt or else return nil if database value is nil already
  def self.decrypt(ciphertext64)
    return nil unless ciphertext64
    ciphertext = Base64.strict_decode64(ciphertext64)
    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    simple_box.decrypt(ciphertext)
  end

  def self.new_salt
    Base64.strict_encode64(
        RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
    )
  end

  def self.hash_password(salt, pwd)
    opslimit = 2**20
    memlimit = 2**24
    digest_size = 64
    digest = RbNaCl::PasswordHash.scrypt(pwd, Base64.strict_decode64(salt),
                                         opslimit, memlimit, digest_size)
    Base64.strict_encode64(digest)
  end

end
