[![Dependency Status](https://gemnasium.com/badges/github.com/TotodileNTHU/Totodile.svg)](https://gemnasium.com/github.com/TotodileNTHU/Totodile)

# Totodie API
API to store and retrieve messages


# To run the server: (old)

1. $ bundle install
2. $ rake db:migrate
3. $ rake db:migrate RACK_ENV=test
4. $ rake db:seed
5. $ rake spec:all
6. $ rake run
7. in your browser 'localhost:3000/'
8. use the following routes

# To run the server: (new)

Install:

Install this API by cloning the *relevant branch* and installing required gems:

    $ bundle install

Testing:

Test this API by running:

    $ RACK_ENV=test rake db:migrate
    $ bundle exec rake spec

Develop:

Run this API during development:

    $ rake db:migrate
    $ bundle exec rackup -p 3000

or use autoloading during development:

    $ bundle exec rerun rackup


## Routes

- get `api/v1/postings`: returns a json of all post with [id, uid, content]
- get `api/v1/postings?uid=[xxx]`: returns a json of all post post by uid
- get `api/v1/postings?id=[xxx]`: returns a json of specific post with id

- get `api/v1/users`: returns a json of all message IDs
- get `api/v1/users/[ID]`: returns a json of all information about a user with given ID


## Deploy to Heroku
