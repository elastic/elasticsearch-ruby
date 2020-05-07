require 'sinatra'
require 'json'
require 'elasticsearch'

class ElasticSinatraApp < Sinatra::Base
  use ElasticAPM::Middleware

  before do
    @client = Elasticsearch::Client.new
  end

  get '/' do
    response = @client.cluster.health
    json_response(response)
  end

  get '/ingest' do
    unless @client.indices.exists(index: 'games')
      @client.indices.create(index: 'games')
    end

    ElasticAPMExample::GAMES.each_slice(250) do |slice|
      @client.bulk(
        body: slice.map do |game|
          { index: { _index: 'games', data: game } }
        end
      )
    end
    json_response(status: 'ok')
  end

  get '/search/:query' do
    query = sanitize(params[:query])
    response = search_elasticsearch(query)
    json_response(response['hits']['hits'])
  end

  get '/delete' do
    response = @client.delete_by_query(
      index: 'games',
      body: {
        query: { match_all: {} }
      }
    )
    json_response(response)
  end

  get '/delete/:id' do
    id = sanitize(params[:id])

    begin
      response = @client.delete(index: 'games', id: id)
      json_response(response)
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      json_response(e, 404)
    end
  end

  get '/update' do
    response = []
    docs = search_elasticsearch

    docs['hits']['hits'].each do |doc|
      response << @client.update(
        index: 'games',
        id: doc['_id'],
        body: {
          doc: {
            modified: DateTime.now
          }
        }
      )
    end
    json_response(response)
  end

  get '/error' do
    begin
      @client.delete(index: 'games', id: 'somerandomid')
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      json_response(e, 404)
    end
  end

  get '/doc/:id' do
    response = @client.get(index: 'games', id: sanitize(params[:id]))
    json_response(response)
  end

  private

  def json_response(response, code = 200)
    [
      code,
      { 'Content-Type' => 'application/json' },
      [response.to_json]
    ]
  end

  def sanitize(params)
    Rack::Utils.escape_html(params)
  end

  def search_elasticsearch(query = '')
    @client.search(
      index: 'games',
      body:
        {
          query: { multi_match: { query: query } }
        }
    )
  end
end
