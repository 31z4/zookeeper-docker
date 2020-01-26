#!/bin/bash

set -e

# UID is read-only var in bash, but there is no GID,
# hence let's define them both
UID_=$(id -u)
GID_=$(id -g)

ZOO_UID=${ZOO_UID:-"$(id -u zookeeper)"}
ZOO_GID=${ZOO_GID:-"$(id -g zookeeper)"}

# Allow the container to be started with `--user`
if [[ "$1" = 'zkServer.sh' && $UID_ = 0 ]]; then
    chown -R "$ZOO_UID":"$ZOO_GID" "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"
    if [[ "$ZOO_UID" != "$UID_" ]] && [[ "$ZOO_GID" != "$GID_" ]]; then
        exec gosu "$ZOO_UID":"$ZOO_GID" "$0" "$@"
    fi
fi

# Generate the config only if it doesn't exist
if [[ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"
    {
        echo "dataDir=$ZOO_DATA_DIR"
        echo "dataLogDir=$ZOO_DATA_LOG_DIR"

        echo "tickTime=$ZOO_TICK_TIME"
        echo "initLimit=$ZOO_INIT_LIMIT"
        echo "syncLimit=$ZOO_SYNC_LIMIT"

        echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT"
        echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL"
        echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS"
        echo "standaloneEnabled=$ZOO_STANDALONE_ENABLED"
        echo "admin.enableServer=$ZOO_ADMINSERVER_ENABLED"
    } >> "$CONFIG"
    if [[ -z $ZOO_SERVERS ]]; then
      ZOO_SERVERS="server.1=localhost:2888:3888;2181"
    fi

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done

    if [[ -n $ZOO_4LW_COMMANDS_WHITELIST ]]; then
        echo "4lw.commands.whitelist=$ZOO_4LW_COMMANDS_WHITELIST" >> "$CONFIG"
    fi

fi

# Write myid only if it doesn't exist
if [[ ! -f "$ZOO_DATA_DIR/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi

exec "$@"
