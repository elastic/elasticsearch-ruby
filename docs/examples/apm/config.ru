require 'elastic-apm'
require_relative './elastic_sinatra_app.rb'

ElasticAPM.start(app: ElasticSinatraApp)

run ElasticSinatraApp

at_exit { ElasticAPM.stop }
