ARG RUBY_TEST_VERSION=2.6
FROM ruby:${RUBY_TEST_VERSION}

ARG TEST_SUITE=client
ENV TEST_SUITE=${TEST_SUITE}

ARG ELASTIC_PASSWORD=changeme
ENV ELASTIC_PASSWORD=${ELASTIC_PASSWORD}


ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV QUIET=true
ENV CI=true

WORKDIR /usr/src/app

COPY . .

RUN gem update --system
RUN gem uninstall bundler
RUN gem install bundler
RUN rake bundle:clean
RUN bundle install
RUN bundle exec rake setup
RUN bundle exec rake elasticsearch:update
RUN rake bundle:install


CMD ["sh", "-c", "rake test:$TEST_SUITE"]
