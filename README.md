# backed for ember cli based crm with multy user types log in
* [Frontend](https://github.com/edikgat/ember-crm-frontend)

includes:
  - 3 user types - admin, user, supply partner
  - user and supply partner can log in only to api
  - admin manages all data


## Installation
### Rails (requestor-rails)
You will need:
  - ruby (2.3.1)
  - mysql
  - redis (to store sesstions of api users)

 After:
  - correct database.yml
  - correct initializers/redis.rb - if you use not standard settings
  - `bundle`
  - `rake db:setup`
  - `rails s`
