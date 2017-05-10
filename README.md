[![Dependency Status](https://gemnasium.com/badges/github.com/TotodileNTHU/Totodile.svg)](https://gemnasium.com/github.com/TotodileNTHU/Totodile)

# Totodie API
API to store and retrieve messages

# To run the server:

1. $ bundle install
2. $ rake db:migrate
3. $ rake db:migrate RACK_ENV=test
4. $ rake spec:all 
5. $ rackup
6. in your browser 'localhost:9292/'
7. use the following routes

## Routes

- get `api/v1/postings`: returns a json of all post with [id, uid, content]
- get `api/v1/postings?uid=[xxx]`: returns a json of all post post by uid
- get `api/v1/postings?id=[xxx]`: returns a json of specific post with id

- get `api/v1/users`: returns a json of all message IDs
- get `api/v1/users/[ID]`: returns a json of all information about a user with given ID


## Deploy to Heroku