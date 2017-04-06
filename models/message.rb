# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl/libsodium'

# Hold the information of message
class Message
  STORE_DIR = 'db/message/'.freeze

  attr_accessor :id, :creater_id, :content

  def initialize(new_message)
    @id = new_message['id'] || new_id
    @creater_id = new_message['creater_id']
    @content = new_message['content']
  end

  def new_id
    Base64.urlsafe_encode64(RbNaCl::Hash.sha256(Time.now.to_s))[0..9]
  end

  def to_json(options = {})
    JSON({ id: @id,
           creater_id: @creater_id,
           content: @content },
         options)
  end

  def save
    File.open(STORE_DIR + @id + '.txt', 'w') do |file|
      file.write(to_json)
    end
  end

  def self.find(find_id)
    message_file = File.read(STORE_DIR + find_id + '.txt')
    Message.new JSON.parse(message_file)
  end

  def self.all
    Dir.glob(STORE_DIR + '*.txt').map do |filename|
      filename.match(/#{Regexp.quote(STORE_DIR)}(.*)\.txt/)[1]
    end
  end

  def self.setup
    Dir.mkdir(Message::STORE_DIR) unless Dir.exist? STORE_DIR
  end
end
