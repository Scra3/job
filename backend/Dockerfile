FROM ruby:3.0.1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install
RUN bundle binstubs --all
