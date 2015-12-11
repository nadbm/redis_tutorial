require 'em-hiredis'

EM.run do
  rand = Random.new
  redis = EM::Hiredis.connect

  color = ENV['COLOR'] || 'green'
  value = 5
  EM::PeriodicTimer.new(0.5) do
    value += rand.rand(-0.5..0.5)
    redis.set("timeseries-data:#{color}", value).callback do
      redis.publish("timeseries-data:#{color}", value)
    end
  end

  trap "INT" do EM.stop_event_loop end  
end