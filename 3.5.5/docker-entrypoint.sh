#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [[ "$1" = 'zkServer.sh' && "$(id -u)" = '0' ]]; then
    chown -R zookeeper "$ZOO_DATA_DIR" "$ZOO_DATA_LOG_DIR" "$ZOO_LOG_DIR" "$ZOO_CONF_DIR"
    exec gosu zookeeper "$0" "$@"
fi

# Generate the config only if it doesn't exist
if [[ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"

    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT" >> "$CONFIG"
    echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL" >> "$CONFIG"
    echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS" >> "$CONFIG"
    echo "standaloneEnabled=$ZOO_STANDALONE_ENABLED" >> "$CONFIG"
    echo "admin.enableServer=$ZOO_ADMINSERVER_ENABLED" >> "$CONFIG"

    if [[ -z $ZOO_SERVERS ]]; then
      ZOO_SERVERS="server.1=localhost:2888:3888;2181"
    fi

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done

    # https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_advancedConfiguration
    if [[ -z $ZOO_GLOBAL_OUTSTANDING_LIMIT ]]; then
      echo "globalOutstandingLimit=$ZOO_GLOBAL_OUTSTANDING_LIMIT" >> "$CONFIG"
    fi
    if [[ -z $ZOO_PRE_ALLOC_SIZE ]]; then
      echo "preAllocSize=$ZOO_PRE_ALLOC_SIZE" >> "$CONFIG"
    fi
    if [[ -z $ZOO_CLIENT_PORT_ADDRESS ]]; then
      echo "clientPortAddress=$ZOO_CLIENT_PORT_ADDRESS" >> "$CONFIG"
    fi
    if [[ -z $ZOO_MIN_SESSION_TIMEOUT ]]; then
      echo "minSessionTimeout=$ZOO_MIN_SESSION_TIMEOUT" >> "$CONFIG"
    fi
    if [[ -z $ZOO_MAX_SESSION_TIMEOUT ]]; then
      echo "maxSessionTimeout=$ZOO_MAX_SESSION_TIMEOUT" >> "$CONFIG"
    fi
    if [[ -z $ZOO_FSYNC_WARNING_THRESHOLD_MS ]]; then
      echo "fsync.warningthresholdms=$ZOO_FSYNC_WARNING_THRESHOLD_MS" >> "$CONFIG"
    fi
    if [[ -z $ZOO_SYNC_ENABLED ]]; then
      echo "syncEnabled=$ZOO_SYNC_ENABLED" >> "$CONFIG"
    fi
    if [[ -z $ZOO_EXTENDED_TYPES_ENABLED ]]; then
      echo "zookeeper.extendedTypesEnabled=$ZOO_EXTENDED_TYPES_ENABLED" >> "$CONFIG"
    fi
    if [[ -z $ZOO_EMULATE_353_TTL_NODES ]]; then
      echo "zookeeper.emulate353TTLNodes=$ZOO_EMULATE_353_TTL_NODES" >> "$CONFIG"
    fi
    if [[ -z $ZOO_SERVER_CNXN_FACTORY ]]; then
      echo "serverCnxnFactory=$ZOO_SERVER_CNXN_FACTORY" >> "$CONFIG"
    fi

fi

# Write myid only if it doesn't exist
if [[ ! -f "$ZOO_DATA_DIR/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi

exec "$@"
