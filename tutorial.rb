require 'em-websocket'
require 'em-hiredis'
require 'thin'
require 'sinatra'

EventMachine.run do

  clients = []

  redis = EM::Hiredis.connect
  redis.pubsub.subscribe("message-box") do |msg|
    clients.each{ |client| client.send(msg)}
  end

  #websocket
  EM::WebSocket.run(:host => "0.0.0.0", :port => 3002) do |ws|
    ws.onopen do |handshake|
      clients << ws
      redis.get("message-box").callback { |res| ws.send(res || '')}
    end

    ws.onclose do  
      clients.delete ws
    end

    ws.onmessage do |msg|
      redis.set("message-box", msg).callback do 
        redis.publish("message-box",msg) 
      end
    end
  end

  #webserver
  class App < Sinatra::Base
    get '/' do send_file 'index.html' end
  end
  Thin::Server.start App, '0.0.0.0', 3000
  trap "INT" do EventMachine.stop_event_loop end  
end

