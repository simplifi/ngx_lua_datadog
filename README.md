# Ngx Lua Datadog connecter

Simple libary extracted from the [Kong](https://github.com/Mashape/kong) project that allows for Datadog(statsd) collection from inside lua scripts running in nginx

## Usage

Include the library code in your nginx configuration, usually inside the http block but outside the server block

```
# set path for lua libraries - ;; means append existing paths
lua_package_path "/path/to/ngx_lua_datadog/lib/?.lua;;";
```

use in a location stanza:
 
```
local conf = { host = "127.0.0.1", port = 8125, namespace = "Lua_Stats_App", timeout = 1}
local statsd_logger = require "ngx_lua_datadog"
local logger, err = statsd_logger:new(conf)

if err then
     ngx_log(ngx.ERR, "failed to create Statsd logger: ", err)
end

if ( my_condition ) then
     logger:counter("condition_matched", 1, 1)
     ngx.exit(204)
else
     logger:counter("condition_not_matched", 1, 1)
     ngx.exit(200)
end
```

## Configuration options
| name | value |
-------|--------
| host | the ip or name of your statsd server |
| port | the port number your statsd server runs on, default is 8125 |
| timeout| the number of seconds for lua to wait to make the connection |
| namespace | the string that all stat messages will be prefixed with |


## Statistic Gathering

```
-- Simple counter 
counter(stat, value, sample_rate, tags)

-- Gauge
gauge(stat, value, sample_rate, tags)

-- Timer
timer(stat, ms, tags)

-- Histogram
histogram(stat, value, tags)

-- Meter
meter(stat, value, tags)

-- Sets
meter(stat, value, tags)
```
Sample rates are your responsiblity to calculate.  If you tell it the sample rate is 0.10 (10 percent), then the **value** you send needs to be the sampled value.  e.g. If you've had 100 hits and you send a 0.20 sample rate, the value you send would be 20

## Tag Format

Tags are sent as comma separated key value pairs with a colon deliminating the key from the value, e.g.
```
tags = "country:china,datacenter:asia,account:mass_market"

logger:count("another_hit", 1, 1, tags)
```





