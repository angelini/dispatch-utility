#!/bin/bash

# Dispatch Starting Script

DIR="$( cd "$( dirname "$0" )" && pwd )"
LOGS="$DIR/logs"

CLIENT_DIR="$DIR/../dispatch-client"
SERVER_DIR="$DIR/../dispatch-server"
UPDATE_DIR="$DIR/../dispatch-utility"
REDIS_CONF="$DIR/redis.conf"

CLIENT_SCRIPT="server.js"
SERVER_SCRIPT="dispatch.js"
UPDATE_SCRIPT="githook.js"

CLIENT_LOG="$LOGS/client.log"
SERVER_LOG="$LOGS/server.log"
UPDATE_LOG="$LOGS/update.log"

CLIENT_ERR="$LOGS/client.err"
SERVER_ERR="$LOGS/server.err"
UPDATE_ERR="$LOGS/update.err"

start() {
  mkdir -p $LOGS

  echo "Starting redis-server $REDIS_CONF"
  redis-server $REDIS_CONF

  echo "Starting $SERVER_SCRIPT"
  cd $SERVER_DIR
  git pull
  npm install
  supervisor $SERVER_SCRIPT >> $SERVER_LOG 2>$SERVER_ERR &

  echo "Starting $CLIENT_SCRIPT"
  cd $CLIENT_DIR
  git pull
  npm install
  supervisor $CLIENT_SCRIPT >> $CLIENT_LOG 2>$CLIENT_ERR &

  echo "Starting $UPDATE_SCRIPT"
  cd $UPDATE_DIR
  git pull
  npm install
  supervisor $UPDATE_SCRIPT >> $UPDATE_LOG 2>$UPDATE_ERR &
}

stop() {
  echo "Stopping redis-server"
  redis-cli shutdown

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
    sleep 3
    start
    ;;
  *)
    echo "Usage $0 {start|stop|restart}"
    exit 1
esac

exit 0
