# Utils

## The Generator

This directory hosts The Generator, a tool that generates the classes for each API endpoint from the [Elasticsearch REST API JSON Specification](https://github.com/elastic/elasticsearch/tree/main/rest-api-spec).

### Generate

To generate the code, you need to have the Elasticsearch REST API spec files in `tmp/rest-api-spec` in the root of the project. You can run a rake task from the root of the project to download the specs corresponding to the current running cluster:
```bash
$ rake es:download_artifacts
```

Once the JSON files have been downloaded, you need to run (from this folder):
```bash
$ thor code:generate
```

- The Ruby code will be generated in `elasticsearch-api/lib/elasticsearch/api/actions`.
- The generator runs Rubocop to autolint and clean up the generated files.
- You can use the environment variable `IGNORE_VERSION` to ignore the current version of the client when generating the source code documentation urls. This is currently used when generating code from `main`:

```bash
$ IGNORE_VERSION=true thor code:generate
```

- You can use the environment variable `BUILD_HASH` to update the build hash for the generated code from the `tmp/rest-api-spec/build_hash` file. This file is updated every time you use the `es:download_artifacts` Rake task is used in the root of the project to download the latest Elasticsearch specs and tests:
```bash
$ BUILD_HASH=true thor code:generate
```

### Development

The main entry point is `generate_source.rb`, which contains a class that implements a Thor task: `generate`:

```
$ thor api:code:generate
```

It uses [Thor::Actions](https://github.com/erikhuda/thor/wiki/Actions)' `template` method and `templates/method.erb` to generate the final code. The `generator` directory contains some helpers used to generate the code. The ERB template is split into partials and you can find all ERB files in the `templates` directory.

There's also a lister task:

```
$ thor api:list
```

It's implemented in `lister.rb` and it lists all the REST API endpoints from the JSON specification.
