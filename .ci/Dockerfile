ARG RUBY_TEST_VERSION=2.6
FROM ruby:${RUBY_TEST_VERSION}

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV QUIET=true
ENV CI=true

WORKDIR /usr/src/app

COPY . .

RUN gem update --system
RUN gem uninstall bundler
RUN gem install bundler
RUN bundle install
RUN bundle exec rake bundle:clean
RUN rake bundle:install
