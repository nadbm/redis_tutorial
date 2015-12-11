require 'em-hiredis'

EM.run do
  rand = Random.new
  redis = EM::Hiredis.connect

  color = ENV['COLOR'] || 'green'
  EM::PeriodicTimer.new(0.5) do
    value = rand.rand(0..0.5)
    redis.set("timeseries-data:#{color}", value).callback do
      redis.publish("timeseries-data:#{color}", value)
    end
  end
end