ARG RUBY_VERSION=${RUBY_VERSION:-3.1}
FROM ruby:$RUBY_VERSION

ENV QUIET=true
ENV CI=true

# Install required tools
 RUN apt-get -q update && apt-get -y install zip curl

WORKDIR /usr/src/app
COPY . .
USER ${BUILDER_USER}:${BUILDER_GROUP}

RUN bundle install \
    && echo "RUBY VERSION:$RUBY_VERSION" \
    && bundle exec rake bundle:clean \
    && rake bundle:install \
    && curl http://127.0.0.1:9200
