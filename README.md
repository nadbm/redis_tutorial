# redis_tutorial
A simple ruby app to show the pubsub features of redis
#Dependencies
Redis
Ruby 2.2.2

#Running
Install dependencies :
```bash
bundle install
```

Run the webserver : 
```bash
ruby tutorial.rb
```

Run data aggregators as another process
```bash
  COLOR=[red,blue,green,orange] ruby data-aggregator.rb
```

Open your browser to localhost:3000 and watch the pretty colors
