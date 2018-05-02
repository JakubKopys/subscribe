# App setup

To setup application on your machine:

- First, create **secrets.yml** file (based on **secrets.yml.example**)

- Install dependencies
```
bundle install
```

- Setup database
```
bundle exec rails db:setup
```

- Run server
```
bundle exec rails s
```
