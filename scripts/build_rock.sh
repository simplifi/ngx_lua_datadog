#!/bin/bash

if [ -z "$1" ]
then
	echo "Usage: sh scripts/build_rock.sh <version>"
	exit
fi

luarocks write_rockspec git+https://github.com/simplifi/ngx_lua_datadog \
	--tag=$1 \
       	--license="Apache 2.0" \
	--homepage="https://github.com/simplifi/ngx_lua_datadog"
