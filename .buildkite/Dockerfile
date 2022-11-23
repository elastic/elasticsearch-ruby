ARG VERSION=${RUBY_VERSION}
FROM ruby:${VERSION}

# Default UID/GID to 1000
# it can be overridden at build time
ARG BUILDER_UID=1000
ARG BUILDER_GID=1000
ENV BUILDER_USER elastic
ENV BUILDER_GROUP elastic

ENV GEM_HOME="/usr/local/bundle"
ENV PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"
ENV QUIET=true
ENV CI=true

# Install required tools
RUN apt-get -q update \
    && apt-get -y install zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create user
RUN groupadd --system -g ${BUILDER_GID} ${BUILDER_GROUP} \
    && useradd --system --shell /bin/bash -u ${BUILDER_UID} -g ${BUILDER_GROUP} -d /var/lib/elastic -m elastic 1>/dev/null 2>/dev/null \
    && mkdir -p /usr/src/app && touch /Gemfile.lock \
    && chown -R ${BUILDER_USER}:${BUILDER_GROUP} /usr/src/app /Gemfile.lock

COPY --chown=$BUILDER_USER:$BUILDER_GROUP . .

WORKDIR /usr/src/app

USER ${BUILDER_USER}:${BUILDER_GROUP}

RUN bundle install \
    && bundle exec rake bundle:clean \
    && rake bundle:install
