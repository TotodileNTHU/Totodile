[![Dependency Status](https://gemnasium.com/badges/github.com/TotodileNTHU/Totodile.svg)](https://gemnasium.com/github.com/TotodileNTHU/Totodile)

# Totodie API
API to store and retrieve messages

# To run the server:

1. $ bundle install
2. $ rake db:migrate
3. $ rake db:migrate RACK_ENV=test
2. $ rackup
3. in your browser 'localhost:9292/'
4. use the following routes

## Routes

- get `api/v1/messages/`: returns a json of all message IDs
- get `api/v1/messages/[ID].json`: returns a json of all information about a configuration with given ID
- get `api/v1/messages/[ID]/content`: returns a text/plain content with a message content for given ID
- post `/api/v1/messages/` : store a message. Request body must be a json, which must contain content of message, creator_id of message, id of message is optional

- get `/api/v1/pokemons/` : returns a json of all pokemon IDs
- get `api/v1/pokemons/[ID].json`: returns a json of all information about a pokemon with given ID
- get `api/v1/pokemons/[ID]/description`: returns a text/plain content with a description of a pokemon for given ID
- post `/api/v1/pokemons/` : store a pokemon information(name and id). Request body must be a json, which must contain name and decription, id of pokemon is optional
