# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl/libsodium'

# Hold the information of pokemon
class Pokemon
  STORE_DIR = 'db/'.freeze

  attr_accessor :id, :name

  def initialize(new_pokemon)
  	@id = new_pokemon['id']
  	@name = new_pokemon['name']
  end

  def new_id
  	base64.urlsafe_encode64(RbNaCl::Hash.sha256(Time.now.to_s))[0..9]
  end

  def to_json(options = {})
  	JSON({ id: @id,
  	       name: @name },
  	    options)
  end

  def save
  	File.open(STORE_DIR + @id + '.txt', 'w') do |file|
  	  file.write(to_json)
  	end
  end

  def self.find(find_id)
  	pokemon_file = File.read(STORE_DIR + find_id + '.txt')
  	Pokemon.new JSON.parse(pokemon_file)
  end

  def self.all
  	Dir.glob(STORE_DIR + '*.txt').map do |filename|
  	  filename.match(/#{Regexp.quote(STORE_DIR)}(.*)\.txt/)[1]
  	end
  end

  def self.setup
    Dir.mkdir(Pokemon::STORE_DIR) unless Dir.exist? STORE_DIR
  end
end
