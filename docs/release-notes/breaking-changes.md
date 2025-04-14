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
