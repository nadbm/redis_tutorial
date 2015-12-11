require 'em-websocket'
require 'em-hiredis'
require 'thin'
require 'sinatra'

EventMachine.run do

  clients = []

  redis = EM::Hiredis.connect
  redis.pubsub.subscribe("timeseries-data") do |msg|
    clients.each{ |client| client.send(msg)}
  end
  #websocket
  EM::WebSocket.run(:host => "0.0.0.0", :port => 3002) do |ws|
    ws.onopen { |handshake| clients << ws}
    ws.onclose { clients.delete ws}  
  end
  #webserver
  class App < Sinatra::Base
    get '/' do send_file 'index.html' end
  end
  Thin::Server.start App, '0.0.0.0', 3000
  trap "INT" do EventMachine.stop_event_loop end  
end

