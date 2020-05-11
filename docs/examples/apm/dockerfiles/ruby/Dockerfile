From ruby:2.7

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY . .
RUN bundle install

EXPOSE 9292

CMD bundle exec rackup -p 9292 config.ru