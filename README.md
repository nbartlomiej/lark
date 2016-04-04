# Lark - gets up and tweets

A simple worker script for Heroku which polls one RSS feed and publishes the
newest item to a chosen Twitter account.

Usage:

- Deploy to Heroku
- Configure ENV variables (see specs)
- Use `./bin/lark` (e.g. with Heroku Scheduler) to run it.
