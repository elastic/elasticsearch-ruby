From ruby:2.7

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY . .
RUN bundle install

EXPOSE 9292

CMD RACK_ENV=production bundle exec rackup -p 9292 --host 0.0.0.0 config.ru