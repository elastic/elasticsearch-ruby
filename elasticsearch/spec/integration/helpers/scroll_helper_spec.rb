# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
require_relative 'helpers_spec_helper'
require 'elasticsearch/helpers/scroll_helper'

context 'Elasticsearch client helpers' do
  let(:index) { 'books' }
  let(:body) { { size: 12, query: { match_all: {} } } }
  let(:scroll_helper) { Elasticsearch::Helpers::ScrollHelper.new(client, index, body) }

  before do
    documents = [
      { index: { _index: index, data: {name: "Leviathan Wakes", "author": "James S.A. Corey", "release_date": "2011-06-02", "page_count": 561} } },
      { index: { _index: index, data: {name: "Hyperion", "author": "Dan Simmons", "release_date": "1989-05-26", "page_count": 482} } },
      { index: { _index: index, data: {name: "Dune", "author": "Frank Herbert", "release_date": "1965-06-01", "page_count": 604} } },
      { index: { _index: index, data: {name: "Dune Messiah", "author": "Frank Herbert", "release_date": "1969-10-15", "page_count": 331} } },
      { index: { _index: index, data: {name: "Children of Dune", "author": "Frank Herbert", "release_date": "1976-04-21", "page_count": 408} } },
      { index: { _index: index, data: {name: "God Emperor of Dune", "author": "Frank Herbert", "release_date": "1981-05-28", "page_count": 454} } },
      { index: { _index: index, data: {name: "Consider Phlebas", "author": "Iain M. Banks", "release_date": "1987-04-23", "page_count": 471} } },
      { index: { _index: index, data: {name: "Pandora's Star", "author": "Peter F. Hamilton", "release_date": "2004-03-02", "page_count": 768} } },
      { index: { _index: index, data: {name: "Revelation Space", "author": "Alastair Reynolds", "release_date": "2000-03-15", "page_count": 585} } },
      { index: { _index: index, data: {name: "A Fire Upon the Deep", "author": "Vernor Vinge", "release_date": "1992-06-01", "page_count": 613} } },
      { index: { _index: index, data: {name: "Ender's Game", "author": "Orson Scott Card", "release_date": "1985-06-01", "page_count": 324} } },
      { index: { _index: index, data: {name: "1984", "author": "George Orwell", "release_date": "1985-06-01", "page_count": 328} } },
      { index: { _index: index, data: {name: "Fahrenheit 451", "author": "Ray Bradbury", "release_date": "1953-10-15", "page_count": 227} } },
      { index: { _index: index, data: {name: "Brave New World", "author": "Aldous Huxley", "release_date": "1932-06-01", "page_count": 268} } },
      { index: { _index: index, data: {name: "Foundation", "author": "Isaac Asimov", "release_date": "1951-06-01", "page_count": 224} } },
      { index: { _index: index, data: {name: "The Giver", "author": "Lois Lowry", "release_date": "1993-04-26", "page_count": 208} } },
      { index: { _index: index, data: {name: "Slaughterhouse-Five", "author": "Kurt Vonnegut", "release_date": "1969-06-01", "page_count": 275} } },
      { index: { _index: index, data: {name: "The Hitchhiker's Guide to the Galaxy", "author": "Douglas Adams", "release_date": "1979-10-12", "page_count": 180} } },
      { index: { _index: index, data: {name: "Snow Crash", "author": "Neal Stephenson", "release_date": "1992-06-01", "page_count": 470} } },
      { index: { _index: index, data: {name: "Neuromancer", "author": "William Gibson", "release_date": "1984-07-01", "page_count": 271} } },
      { index: { _index: index, data: {name: "The Handmaid's Tale", "author": "Margaret Atwood", "release_date": "1985-06-01", "page_count": 311} } },
      { index: { _index: index, data: {name: "Starship Troopers", "author": "Robert A. Heinlein", "release_date": "1959-12-01", "page_count": 335} } },
      { index: { _index: index, data: {name: "The Left Hand of Darkness", "author": "Ursula K. Le Guin", "release_date": "1969-06-01", "page_count": 304} } },
      { index: { _index: index, data: {name: "The Moon is a Harsh Mistress", "author": "Robert A. Heinlein", "release_date": "1966-04-01", "page_count": 288 } } }
    ]
    client.bulk(body: documents, refresh: 'wait_for')
  end

  after do
    client.indices.delete(index: index)
  end

  it 'instantiates a scroll helper' do
    expect(scroll_helper).to be_an_instance_of Elasticsearch::Helpers::ScrollHelper
  end

  it 'searches an index' do
    my_documents = []
    while !(documents = scroll_helper.results).empty?
      my_documents << documents
    end

    expect(my_documents.flatten.size).to eq 24
  end

  it 'uses enumerable' do
    count = 0
    scroll_helper.each { |a| count += 1 }
    expect(count).to eq 24
    expect(scroll_helper).to respond_to(:count)
    expect(scroll_helper).to respond_to(:reject)
    expect(scroll_helper).to respond_to(:uniq)
    expect(scroll_helper.map { |a| a['_id'] }.uniq.count).to eq 24
  end
end
