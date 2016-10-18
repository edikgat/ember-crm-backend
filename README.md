# Backend for ember cli based crm with multi user types
* [Frontend](https://github.com/edikgat/ember-crm-frontend)

includes:
  - 3 user types - admin, user, supply partner
  - user and supply partner can log in only to api
  - admin manages all data


## Installation
### CRM-backend
You will need:
  - `ruby` (2.3.1)
  - `mysql`
  - `redis` (to store users api sessions)

#### To run rails at development:
1. Correct database.yml and redis.yml:

        $ cp config/database.yml.example config/database.yml
        $ cp config/redis.yml.example config/redis.yml

2. Run bundler:

        $ bundle

3. Prepare a database:

        $ rake db:setup
4. Run rails server:

        $ rails s

#### To run tests:
    $ RAILS_ENV=test rake db:create
    $ RAILS_ENV=test rake db:schema:load
    $ rspec spec/
