#!/bin/bash

# Dispatch Starting Script

DIR="$( cd "$( dirname "$0" )" && pwd )"
CLIENT_DIR="$DIR/../dispatch-client"
SERVER_DIR="$DIR/../dispatch-server"
REDIS_CONF="$DIR/redis.conf"

CLIENT_SCRIPT="server.js"
SERVER_SCRIPT="dispatch.js"

CLIENT_LOG="$DIR/client.log"
SERVER_LOG="$DIR/server.log"

CLIENT_ERR="$DIR/client.err"
SERVER_ERR="$DIR/server.err"

start() {
  echo "Starting redis-server $REDIS_CONF"
  redis-server $REDIS_CONF

  echo "Starting $SERVER_SCRIPT"
  cd $SERVER_DIR
  supervisor $SERVER_SCRIPT >> $SERVER_LOG 2>$CLIENT_ERR &

  echo "Starting $CLIENT_SCRIPT"
  cd $CLIENT_DIR
  supervisor $CLIENT_SCRIPT >> $CLIENT_LOG 2>$SERVER_ERR &
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
