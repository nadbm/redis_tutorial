require 'em-hiredis'

EM.run do
  rand = Random.new
  redis = EM::Hiredis.connect
  EM::PeriodicTimer.new(0.5) do
    value = rand.rand(0..0.5)
    #set random value
    redis.set("timeseries-data", value).callback do
      puts value
      #publish the value
      redis.publish("timeseries-data", value)
    end
  end
end