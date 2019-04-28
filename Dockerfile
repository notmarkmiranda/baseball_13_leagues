FROM ruby:2.5.1

ENV APP_HOME /baseball_13_leagues

# installation of dependencies
RUN apt-get update -qq \
  && apt-get install -y \
    # needed for certain gems
    build-essential \
    # needed for postgres gem
    libpq-dev \
    # the following are used to trim down the size of the image by removing unneeded data
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

# create a directory for our application and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# add gemfile and install gems
ADD Gemfile* $APP_HOME/
RUN bundle install

# copy over application code
ADD . $APP_HOME

# run app
CMD RAILS_ENV=${RAIL_ENV} bundle exec rails db:create db:migrate db:seed && bundle exec rails s -p ${PORT} -b '0.0.0.0'
