RelevamientosArt
===============

## API Documentation

`URL:` http://relevamientos-art.herokuapp.com/

`Headers`: 
  + For GET requests: `Accept: application/json`
  + For POST requests (with a body): `Content-Type: application/json`

### Institutions

Details of an Institution: `GET /institutions/:id`

### Visits

List of all visits: `GET /visits{?status=:some_status&user_id=:id}`

Details of a visit: `GET /visits/:id`

## Ruby on Rails Learning
Recomended sites to start discovering Ruby and the Ruby on Rails framework!
- [Try Ruby online](http://tryruby.org/levels/1/challenges/0)
- [First Ruby on Rails interactive course](http://railsforzombies.org/)

Useful links to start learning how to program in Ruby language, and particulary on Ruby on Rails framework
- https://betterexplained.com/articles/starting-ruby-on-rails-what-i-wish-i-knew/
- https://betterexplained.com/articles/intermediate-rails-understanding-models-views-and-controllers/
- https://hackhands.com/beginners-guide-ruby/
- http://librosweb.es/libro/introduccion_rails/

## Running local server

### Git pre push hook

You can modify the [pre-push.sh](script/pre-push.sh) script to run different scripts before you `git push` (e.g Rspec, Linters). Then you need to run the following:

```bash
  chmod +x script/pre-push.sh
  ln -s ../../script/pre-push.sh .git/hooks/pre-push
```

You can skip the hook by adding `--no-verify` to your `git push`.

### 1- Installing Ruby

- Clone the repository by running `git clone https://github.com/ignaciocapuccio/Relevamientos-ART.git`
- Go to the project root by running `cd Relevamientos-ART`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### 2- Installing Rails gems

- Install [Bundler](http://bundler.io/).

```bash
  gem install bundler --no-ri --no-rdoc
  rbenv rehash
```
- Install basic dependencies if you are using Ubuntu:

```bash
  sudo apt-get install build-essential libpq-dev nodejs
```

- Install all the gems included in the project.

```bash
  bundle -j 20
```

### [Kickoff] Application Setup



The app is ready!

### Database Setup

Run in terminal:

```bash
  sudo -u postgres psql
  CREATE ROLE "Relevamientos-ART" LOGIN CREATEDB PASSWORD 'Relevamientos-ART';
```

Log out from postgres and run:

```bash
  bundle exec rake db:create db:migrate
```

Your server is ready to run. You can do this by executing `rails server` and going to [http://localhost:3000](http://localhost:3000).

## Running with Docker

Read more [here](docs/docker.md)

## Deploy Guide

#### Heroku

If you we want to deploy the app using [Heroku](https://www.heroku.com) you need to do the following:

- Add the Heroku Git URL to your remotes
- Push to heroku

```bash
	git remote add heroku-prod your-git-url
	git push heroku-prod your-branch:master
```

##### Rbenv

If you have an error while executing `install_bundler` capistrano task then modify the `~/.bash_profile` as indicated [here](https://github.com/rbenv/rbenv#basic-github-checkout).

and run `rbenv global` with the version in [.ruby-version](.ruby-version)

##### Sidekiq

If Sidekiq start fails when you make the first deploy. You can comment the sidekiq lines in [deploy.rb](config/deploy.rb) and [Capfile](Capfile) during the first deploy.

## Rollbar Configuration

[![Error Tracking](https://d26gfdfi90p7cf.cloudfront.net/rollbar-badge.144534.o.png)](https://rollbar.com)

`Rollbar` is used for exception errors report. To complete this configuration setup the following environment variables in your server
- `ROLLBAR_ACCESS_TOKEN`

with the credentials located in the rollbar application.

If you have several servers with the same environment name you may want to difference them in Rollbar. For this set the `ROLLBAR_ENVIRONMENT` environment variable with your environment name.

## Staging Environment

For the staging environment label to work, set the `TRELLO_URL` environment variable.

## Google Analytics

Modified the `XX-XXXXXXX-X` code in the [_google_analytics.html.slim](app/views/layouts/_google_analytics.html.slim) file

## SEO Meta Tags

Just add a the `meta` element to your view.

For example

```html
  = meta title: "My Title", description: "My description", keywords: %w(keyword1 keyword2)
```

You can read more about it [here](https://github.com/lassebunk/metamagic)

## Brakeman

To run the static analyzer for security vulnerabilities run:

```bash
  bundle exec brakeman -z -i config/brakeman.ignore
```

## PGHero Authentication

Set the following variables in your server.

```bash
  PGHERO_USERNAME=username
  PGHERO_PASSWORD=password
```

And you can access the PGHero information by entering `/pghero`.

## Dotenv

We use [dotenv](https://github.com/bkeepers/dotenv) to set up our environment variables in combination with `secrets.yml`.

For example, you could have the following `secrets.yml`:

```yml
production: &production
  foo: <%= ENV['FOO'] %>
  bar: <%= ENV['BAR'] %>
```

and a `.env` file in the project root that looks like this:

```
FOO=1
BAR=2
```

When you load up your application, `Rails.application.secrets.foo` will equal `ENV['FOO']`, making your environment variables reachable across your Rails app.
The `.env` will be ignored by `git` so it won't be pushed into the repository, thus keeping your tokens and passwords safe.

# Debugging Chrome Console

It is a simple and useful way to look at Rails logs without having to look at the console, it also show queries executed and response times.
Install the Rails Panel Extension (https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg). This is recommended way of installing extension, since it will auto-update on every new version. Note that you still need to update meta_request gem yourself.

![railspanel](https://cloud.githubusercontent.com/assets/4494/3090049/917e5378-e586-11e3-9bd4-1db232968126.png)

# Documentation

You can find more documentation in the [docs](docs) folder. The documentation available is:

- [Run locally with Docker](docs/docker.md)
- [Deploy with Elastic Beanstalk](docs/deploy.rb)

## Generating API documentation

You can generate API documentation running:

```bash
bundle exec rake dictum:document
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rspec tests (`bundle exec rspec spec -fd`)
5. Run scss lint (`bundle exec scss-lint app/assets/stylesheets/`)
6. Run rubocop lint (`bundle exec rubocop app spec -R`)
7. Push your branch (`git push origin my-new-feature`)
8. Create a new Pull Request
