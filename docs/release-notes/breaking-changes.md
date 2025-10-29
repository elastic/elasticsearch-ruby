---
navigation_title: "Breaking changes"
---

# Elasticsearch Ruby Client breaking changes [elasticsearch-ruby-client-breaking-changes]
Breaking changes can impact your Elastic applications, potentially disrupting normal operations. Before you upgrade, carefully review the Elasticsearch Ruby Client breaking changes and take the necessary steps to mitigate any issues. To learn how to upgrade, check [Upgrade](docs-content://deploy-manage/upgrade.md).

% ## Next version [elasticsearch-ruby-client-nextversion-breaking-changes]

% ::::{dropdown} Title of breaking change
% Description of the breaking change.
% For more information, check [PR #](PR link).
% **Impact**<br> Impact of the breaking change.
% **Action**<br> Steps for mitigating deprecation impact.
% ::::

## 9.2.0 [elasticsearch-ruby-client-9.2.0-breaking-changes]

The request body, `:body` parameter, is now required in the following APIs:

* `close_point_in_time`
* `fleet.search`
* `graph.explore`
* `index_lifecycle_management.move_to_step`
* `index_lifecycle_management.put_lifecycle`
* `indices.analyze`
* `indices.put_data_lifecycle`
* `indices.put_data_stream_options`
* `indices.shrink`
* `indices.split`
* `inference.completion`
* `inference.inference`
* `inference.put_alibabacloud`
* `inference.put_amazonbedrock`
* `inference.put_amazonsagemaker`
* `inference.put_anthropic`
* `inference.put_azureaistudio`
* `inference.put_azureopenai`
* `inference.put_cohere`
* `inference.put_custom`
* `inference.put_deepseek`
* `inference.put_elasticsearch`
* `inference.put_elser`
* `inference.put_googleaistudio`
* `inference.put_googlevertexai`
* `inference.put_hugging_face`
* `inference.put_jinaai`
* `inference.put_mistral`
* `inference.put_openai`
* `inference.put_voyageai`
* `inference.put_watsonx`
* `inference.rerank`
* `inference.sparse_embedding`
* `inference.stream_completion`
* `inference.text_embedding`
* `render_search_template`
* `scripts_painless_execute`
* `snapshot_lifecycle_management.put_lifecycle`
* `terms_enum`

## 9.0.1 [elasticsearch-ruby-client-9.0.1-breaking-changes]

This release fixes an omission in `9.0.0`. The client sends the `Accept` and `Content-Type` headers to Elasticsearch with the value 'application/vnd.elasticsearch+json; compatible-with=9' to ensure compatibility with Elastic Stack 9.0. You can [customize the HTTP headers](/reference/advanced-config.md#custom-http-headers) when instantiating the client or per request. Note that a compatible version is required on both `Content-Type` and `Accept` headers.

## 9.0.0 [elasticsearch-ruby-client-900-breaking-changes]

### Scroll APIs need to send scroll_id in request body

Sending the `scroll_id` as a parameter has been deprecated since version 7.0.0. It needs to be specified in the request body for `clear_scroll` and `scroll`.

**Impact**<br>

Client code using `clear_scroll` or `scroll` APIs and the deprecated `scroll_id` as a parameter needs to be updated.

**Action**<br>

If you are using the `clear_scroll` or `scroll` APIs, and sending the `scroll_id` as a parameter, you need to update your code to send the `scroll_id` as part of the request body:
```ruby
# Before:
client.clear_scroll(scroll_id: scroll_id)
# Now:
client.clear_scroll(body: { scroll_id: scroll_id })

# Before:
client.scroll(scroll_id: scroll_id)
# Now:
client.scroll(body: { scroll_id: scroll_id })
```
% ::::
