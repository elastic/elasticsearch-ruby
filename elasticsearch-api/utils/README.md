# Utils

## The Generator

This directory hosts The Generator, a tool that generates the classes for each API endpoint from the [Elasticsearch REST API JSON Specification](https://github.com/elastic/elasticsearch/tree/master/rest-api-spec).

### Generate

To generate the code, you need to run (from this folder):
```bash
$ thor api:code:generate
```

- The oss Ruby code will be generated in `elasticsearch-api/lib/elasticsearch/api/actions`.  
- The xpack Ruby code will be generated in `elasticsearch-xpack/lib/elasticsearch/xpack/api/actions`.
- The generator runs Rubocop to autolint and clean up the generated files.

Alternatively, you can pass in `oss` or `xpack` as parameters to generate only one of the 2 sets of endpoints:

```bash
$ thor api:code:generate --api=xpack
$ thor api:code:generate --api=oss
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
