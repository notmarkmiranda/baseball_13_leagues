FROM ruby:2.5.1-alpine

RUN apk add --update build-base postgresql-dev tzdata nodejs ncurses
RUN gem install rails -v '5.2.2'

WORKDIR /app

ADD Gemfile Gemfile.lock /app/

RUN bundle install

ENV TZ=America/Denver

ADD . .
CMD ["bundle", "exec", "puma"]
