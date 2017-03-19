# Prog::Members

[![Code Climate](https://codeclimate.com/github/ProgressiveCoders/prog-members/badges/gpa.svg)](https://codeclimate.com/github/ProgressiveCoders/prog-members) [![Build Status](https://travis-ci.org/rthbound/prog-members.svg?branch=master)](https://travis-ci.org/rthbound/prog-members)

## Usage

Copy `.env.example` to `.env` and ensure you update it with real credentials.

Next run `bundle exec rake test` to ensure all systems are go.

Finally, `bin/sync` oughta do something fun with slack and airtable.

There's also a rake task that will simply run `bin/sync`:

    rake prog:members:sync

## Testing

Integration tests essentially check that the tokens for Slack and for Airtable are set and are valid.

Unit tests run against mocks and don't touch either API.

    bundle exec rake test

## Dependencies

- ["airrecord"](https://github.com/sirupsen/airrecord)
- ["slack-ruby-client"](https://github.com/slack-ruby/slack-ruby-client)

## Development

First Goal: use the slack gem to get member lists and info, then use the airtable gem (airrecord) to update the Airtable document with latest info. :check:

Next Goals: clean it up; automate build; release a rubygem(?); have fun :)

## Deployment

Heroku:

    git clone git@github.com:ProgressiveCoders/prog-members.git
    heroku create
    heroku ps:scale web=1
    heroku addons:create scheduler:standard

Next configure the scheduler addon to run the following task as often as you like:

    rake prog:members:sync

And set environment variables:

    heroku config:set SLACK_API_TOKEN=xoxp-the-real-one \
                      AIRTABLE_KEY=keyTherealone        \
                      AIRTABLE_APP=appSomeRealOne       \
                      AIRTABLE_BASE="Real Table Name"   \

Finally,

    git push heroku master # might need to use --force

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ProgressiveCoders/prog-members.
