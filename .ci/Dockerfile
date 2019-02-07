ARG RUBY_TEST_VERSION=2.6
FROM ruby:${RUBY_TEST_VERSION}

ARG TEST_SUITE=client
ENV TEST_SUITE=${TEST_SUITE}


ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV QUIET=true

WORKDIR /usr/src/app

COPY . .

RUN bundle install
RUN bundle exec rake setup
RUN bundle exec rake elasticsearch:update
RUN rake bundle:clean
RUN rake bundle:install


CMD ["sh", "-c", "rake test:$TEST_SUITE"]
