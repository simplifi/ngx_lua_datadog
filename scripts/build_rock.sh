#!/bin/bash

if [ -z "$1" ]
then
	echo "Usage: sh scripts/build_rock.sh <version>"
	exit
fi

sed -e "s/VERSION/$1/g" ngx_lua_datadog_TEMPLATE.rockspec > ngx_lua_datadog-$1-1.rockspec

luarocks pack ngx_lua_datadog-$1-1.rockspec
