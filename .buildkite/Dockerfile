ARG RUBY_VERSION=${RUBY_VERSION:-3.1}
ARG RUBY_SOURCE=${RUBY_SOURCE:-ruby}
FROM $RUBY_SOURCE:$RUBY_VERSION

ARG QUIET=${QUIET:-true}
ARG CI=${CI:-false}
ENV QUIET=$QUIET
ENV CI=$CI
ARG TRANSPORT_VERSION=${TRANSPORT_VERSION:-8}

# Install required tools
RUN apt-get -q update && apt-get -y install zip curl git
WORKDIR /usr/src/app
COPY . .
RUN bundle install \
    && bundle exec rake bundle:clean \
    && rake bundle:install
