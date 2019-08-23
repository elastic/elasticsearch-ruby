# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require_relative 'spec_helper'

describe 'CheckRunning documentation examples' do
  let(:client) do
    DEFAULT_CLIENT
  end

  it 'executes the example code - 3d1ff6097e2359f927c88c2ccdb36252' do
    # tag::3d1ff6097e2359f927c88c2ccdb36252[]
    response = client.info
    # end::3d1ff6097e2359f927c88c2ccdb36252[]

    puts '-'*50
    puts response
    puts '-'*50
  end
end
