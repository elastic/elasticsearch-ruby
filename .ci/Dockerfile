ARG RUBY_TEST_VERSION=2.5
FROM ruby:${RUBY_TEST_VERSION}

WORKDIR /usr/src/app

COPY . .

RUN bundle install
RUN bundle exec rake setup
RUN bundle exec rake elasticsearch:update
RUN rake bundle:clean
RUN rake bundle:install


CMD [ "rake", "test:unit" ]
