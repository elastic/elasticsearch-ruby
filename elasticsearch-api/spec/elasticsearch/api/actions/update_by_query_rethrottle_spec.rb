# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#update_by_query_rethrottle' do

  let(:task_id) { "abcd:1234" }

  let(:requests_per_second) { 1000 }

  let(:expected_args) do
    [
        'POST',
        "_update_by_query/#{task_id}/_rethrottle",
        { requests_per_second: requests_per_second },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.update_by_query_rethrottle(
      task_id: task_id,
      requests_per_second: requests_per_second
    )).to eq({})
  end
end
