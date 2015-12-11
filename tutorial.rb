require 'em-websocket'
require 'em-hiredis'
require 'thin'
require 'sinatra'

EM.run do

  clients = []

  redis = EM::Hiredis.connect

  redis.pubsub.subscribe("timeseries-data:red") do |msg|
    clients.each{ |client| client.send("red:"+ msg)}
  end

  redis.pubsub.subscribe("timeseries-data:green") do |msg|
    clients.each{ |client| client.send("green:"+ msg)}
  end

  redis.pubsub.subscribe("timeseries-data:blue") do |msg|
    clients.each{ |client| client.send("blue:"+ msg)}
  end
  
  redis.pubsub.subscribe("timeseries-data:orange") do |msg|
    clients.each{ |client| client.send("orange:"+ msg)}
  end

  EM::WebSocket.run(:host => "0.0.0.0", :port => 3002) do |ws|
    ws.onopen { |handshake| clients << ws}
    ws.onclose { clients.delete ws}  
  end

  class App < Sinatra::Base
    get '/' do send_file 'index.html' end
  end

  Thin::Server.start App, '0.0.0.0', 3000

  trap "INT" do EM.stop_event_loop end  
end

