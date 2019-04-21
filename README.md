# Zipline #

Orders need to be delivered to hospitals, this app does some really simple
dispatch calculations to ensure that emergency orders are prioritized and all
orders are eventually delivered.

The implementation is rough, there are a lot of relatively obvious efficiency
improvements, but the main aim at the moment is to deliver emergency orders as
quickly as possible.

It has opinions on how long we can leave resupply orders before delivering them.
It's currently set to 1 hour, as defined by the RESUPPLY_MAX_WAIT variable in
the OrderManager class. Interestingly if you increase this to two hours the
average emergency wait time actually increases with only a very marginal decline
in flights taken, if you decrease it to half an hour emergency wait times also
increase. So an hour seems to be a good place for this initial implementaton.

In the example run we regenerate the schedule and dispatch orders every 30
seconds. Bringing this down to 1 second doesn't have a material difference on
the outcome and would be computationally very expensive in the real world, so 30
seconds seems like a good starting point.

There are some demo input files in the app root (orders.csv & hospitals.csv).
When the example run is executed the following output is achieved:

```
Delivered 300 orders over 108 flights

Average emergency dispatch delay (seconds): 324.8703703703704
Average resupply dispatch delay (seconds): 6386.462962962963

Average emergency order duration (seconds): 1953.3573868539995
Average resupply order duration (seconds): 11668.686197078636
```

## Run the thing ##

This app requires ruby to run, so install that, for example with rbenv.

### Install dependencies ###

```
gem install rspec
gem install simplecov
```

### Demo run ###
```
bin/run_scheduler.rb ./hospitals.csv ./orders.csv
```

### Specs ###
```
rspec
```

