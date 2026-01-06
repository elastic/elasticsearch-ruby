# Vector 64 benchmark

This benchmark script tests `client.pack_dense_vector` in the client. It is to be run with Elasticsearch 9.3.0-SNAPSHOT. By default it connects to `http://localhost:9200` with security disabled. It downloads the necessary data and produces a json file: `results.json`.

Run with:

```bash
bundle install
bundle exec ruby app.rb
```
