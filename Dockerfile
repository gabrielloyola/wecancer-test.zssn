# A simple Dockerfile for a RoR application

FROM ruby:3.0.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /zssn

WORKDIR /zssn

ADD Gemfile /zssn/Gemfile
ADD Gemfile.lock /zssn/Gemfile.lock

RUN bundle install
ADD . /zssn
