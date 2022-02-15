#!/bin/bash

check_api(){
    DURATION=$(</dev/stdin)
    if (($DURATION <= 5000 )); then 
        exit 60
    else
        spark-wallet --version
        RES=$?
        if test "$RES" != 0; then
            echo "API is unreachable" >&2
            exit 1
        fi
    fi
}

check_web(){
    DURATION=$(</dev/stdin)
    if (($DURATION <= 15000 )); then 
        exit 60
    else
        curl --silent --fail spark-wallet.embassy:80
        RES=$?
        if test "$RES" != 0; then
            echo "Web interface is unreachable" >&2
            exit 1
        fi
    fi
}

case "$1" in
	api)
        check_api
        ;;
	web)
        check_web
        ;;
    *)
        echo "Usage: $0 [command]"
        echo
        echo "Commands:"
        echo "         api"
        echo "         web"
esac