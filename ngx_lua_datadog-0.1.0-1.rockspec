package = "ngx_lua_datadog"
version = "0.1.0-1"
source = {
   url = "https://github.com/simplifi/ngx_lua_datadog",
   tag = "v0.1.0"
}
description = {
   detailed = "Simple libary extracted from the [Kong](https://github.com/Mashape/kong) project that allows for Datadog(statsd) collection from inside lua scripts running in nginx",
   homepage = "https://github.com/simplifi/ngx_lua_datadog",
   license = "Apache 2.0"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ["lib.ngx_lua_datadog"] = "lib/ngx_lua_datadog.lua"
   }
}
