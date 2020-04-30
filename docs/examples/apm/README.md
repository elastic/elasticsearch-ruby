# Observability Example

This example provides a docker-compose file from the [Quick start development environment](https://www.elastic.co/guide/en/apm/get-started/current/quick-start-overview.html) for APM. It gets the default distributions of Elasticsearch, Kibana and APM Server up and running in Docker.

Run `docker-compose up` on the root folder of this example and you'll get everything set up. Follow the steps on the full documentation [at elastic.co](https://www.elastic.co/guide/en/apm/get-started/current/quick-start-overview.html) to get APM set up in your Kibana instance.

Once you have Elasticsearch, Kibana and APM running, run the Ruby app:

```bash
$ bundle install
$ rackup
```

Use your web browser or `curl` against http://localhost:9292/ to check that everything is working. You should see a JSON response from `cluster.health`.

# Routes

Once the app is running, you can open the following routes in your web browser or via `curl`:

* `localhost:9292/` - The root path returns the response from `cluster.health`
* `localhost:9292/ingest` - This will bulk insert 1,000 documents in the `games` index in slices of 250 at a time.
* `localhost:9292/search/{param}` - Returns search results for `param`.
* `localhost:9292/error` - This route will trigger an error.
* `localhost:9292/delete` - This route will delete all the data in the `games` index.
* `localhost:9292/delete/{id}` - This route will delete a document with the given id from the `games` index.

# Data Source

Data is based on a DB dump from February 25, 2020 of [TheGamesDB](https://thegamesdb.net/) game data:  
https://cdn.thegamesdb.net/json/database-latest.json


