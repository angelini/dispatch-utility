#!/bin/bash

# Dispatch Starting Script

DIR="$( cd "$( dirname "$0" )" && pwd )"
CLIENT_DIR="$DIR/../dispatch-client"
SERVER_DIR="$DIR/../dispatch-server"
REDIS_CONF="$DIR/redis.conf"

CLIENT_SCRIPT="server.js"
SERVER_SCRIPT="dispatch.js"

start() {
  echo "Starting redis-server $REDIS_CONF"
  redis-server $REDIS_CONF

  echo "Starting $SERVER_SCRIPT"
  cd $SERVER_DIR
  supervisor $SERVER_SCRIPT &

  echo "Starting $CLIENT_SCRIPT"
  cd $CLIENT_DIR
  supervisor $CLIENT_SCRIPT
}

stop() {
  echo "Stopping redis-server"
  killall redis-server

  echo "Stopping node"
  killall node
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart|reload)
    stop
    start
    ;;
  *)
    echo "Usage $0 {start|stop|restart}"
    exit 1
esac

exit 0
