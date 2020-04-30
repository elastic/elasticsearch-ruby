require 'net/http'

endpoints = [
  'http://ruby_app:9292/',
  'http://ruby_app:9292/ingest',
  'http://ruby_app:9292/search/mario',
  'http://ruby_app:9292/search/sonic',
  'http://ruby_app:9292/search/donkeykong',
  'http://ruby_app:9292/search/bubsy',
  'http://ruby_app:9292/delete',
  'http://ruby_app:9292/update',
  'http://ruby_app:9292/error',
]

def sample_fibonacci
  [1, 2, 3, 5, 8, 13, 21].sample
end

while true
  sample_fibonacci.times do
    uri = URI(endpoints.sample)
    req = Net::HTTP::Get.new(uri)
    req['content-type'] = 'application/json'
    Thread.new do
      Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
    end
    sleep 1
  end
end
