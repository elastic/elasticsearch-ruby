# $ docker build --file benchmarks/Dockerfile --tag elastic/elasticsearch-ruby .

ARG  RUBY_VERSION=2.7
FROM ruby:${RUBY_VERSION}

ENV TERM xterm-256color
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

VOLUME ["/data"]

WORKDIR /elasticsearch-ruby

# TODO(karmi): Copy dependencies first to make use of Docker layer caching
COPY . .

RUN bundle install --retry=5
RUN cd benchmarks && bundle install

CMD ["/bin/bash"]
