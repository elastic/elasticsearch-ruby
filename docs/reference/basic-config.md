---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/basic-config.html
---

# Basic configuration [basic-config]

The table below contains the most important initialization parameters that you can use.

|     |     |     |
| --- | --- | --- |
| **Parameter** | **Data type** | **Description** |
| `adapter` | Symbol | A specific adapter for Faraday (for example, `:patron`). |
| `api_key` | String, Hash | For API key Authentication. Either the base64 encoding of `id` and `api_key` joined by a colon as a string, or a hash with the `id` and `api_key` values. |
| `compression` | Boolean | Whether to compress requests. Gzip compression is used. Defaults to `false`. Responses are automatically inflated if they are compressed. If a custom transport object is used, it must handle the request compression and response inflation. |
| `enable_meta_header` | Boolean | Whether to enable sending the meta data header to Cloud. Defaults to `true`. |
| `hosts` | String, Array | Single host passed as a string or hash, or multiple hosts passed as an array; `host` or `url` keys are also valid. |
| `log` | Boolean | Whether to use the default logger. Disabled by default. |
| `logger` | Object | An instance of a Logger-compatible object. |
| `opaque_id_prefix` | String | Sets a prefix for X-Opaque-Id when initializing the client. This is prepended to the id you set before each request if you’re using X-Opaque-Id. |
| `opentelemetry_tracer_provider` | `OpenTelemetry::Trace::TracerProvider` | An explicit TracerProvider to use instead of the global one with OpenTelemetry. This enables better dependency injection and simplifies testing. |
| `randomize_hosts` | Boolean | Whether to shuffle connections on initialization and reload. Defaults to `false`. |
| `reload_connections` | Boolean, Number | Whether to reload connections after X requests. Defaults to `false`. |
| `reload_on_failure` | Boolean | Whether to reload connections after failure. Defaults to `false`. |
| `request_timeout` | Integer | The request timeout to be passed to transport in options. |
| `resurrect_after` | Integer | Specifies after how many seconds a dead connection should be tried again. |
| `retry_on_failure` | Boolean, Number | Whether to retry X times when request fails before raising and exception. Defaults to `false`. |
| `retry_on_status` | Array, Number | Specifies which status code needs to be returned to retry. |
| `selector` | Constant | An instance of selector strategy implemented with {Elastic::Transport::Transport::Connections::Selector::Base}. |
| `send_get_body_as` | String | Specifies the HTTP method to use for GET requests with a body. Defaults to `GET`. |
| `serializer_class` | Constant | Specifies a serializer class to use. It is initialized by the transport and passed the transport instance. |
| `sniffer_timeout` | Integer | Specifies the timeout for reloading connections in seconds. Defaults to `1`. |
| `trace` | Boolean | Whether to use the default tracer. Disabled by default. |
| `tracer` | Object | Specifies an instance of a Logger-compatible object. |
| `transport` | Object | Specifies a transport instance. |
| `transport_class` | Constant | Specifies a transport class to use. It is initialized by the client and passed hosts and all arguments. |
| `transport_options` | Hash | Specifies the options to be passed to the `Faraday::Connection` constructor. |
