require 'elastic-apm'
require_relative './elastic_sinatra_app.rb'
require_relative './games_data.rb'

ElasticAPM.start(app: ElasticSinatraApp)

run ElasticSinatraApp

at_exit { ElasticAPM.stop }
