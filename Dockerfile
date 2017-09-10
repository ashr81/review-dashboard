FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /review-dashboard
WORKDIR /review-dashboard

ADD Gemfile /review-dashboard/Gemfile
ADD Gemfile.lock /review-dashboard/Gemfile.lock

RUN bundle install

ADD . /review-dashboard
