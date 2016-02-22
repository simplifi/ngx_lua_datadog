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
local conf = { host = "127.0.0.1", port = 8125, prefix = "Lua_Stats_App"}
local statsd_logger = require "ngx_lua_statsd"
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
| prefix | the string that all stat messages will be prefixed with |


## Statistic Gathering

```
-- Simple counter 
counter(stat, value, sample_rate)

-- Gauge
gauge(stat, value, sample_rate)

-- Timer
timer(stat, ms)

-- Histogram
histogram(stat, value)

-- Meter
meter(stat, value)

-- Sets
meter(stat, value)
```
Sample rates are your responsiblity to calculate.  If you tell it the sample rate is 0.10 (10 percent), then the **value** you send needs to be the sampled value.  e.g. If you've had 100 hits and you send a 0.20 sample rate, the value you send would be 20




