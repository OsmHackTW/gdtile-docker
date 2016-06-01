#!/bin/sh

if [ -z $PG_ENV_POSTGRES_PASSWORD ] \
    || [ -z $PG_ENV_POSTGRES_DB ] \
    || [ -z $PG_ENV_POSTGRES_USER ] \
    || [ -z $PG_PORT_5432_TCP_ADDR ] \
    || [ -z $PG_PORT_5432_TCP_PORT ] ; then
        echo "missing Progress settings"

cat <<EOF
PG_PORT_5432_TCP_ADDR=$PG_PORT_5432_TCP_ADDR
PG_PORT_5432_TCP_PORT=$PG_PORT_5432_TCP_PORT
PG_ENV_POSTGRES_DB=$PG_ENV_POSTGRES_DB
PG_ENV_POSTGRES_USER=$PG_ENV_POSTGRES_USER
PG_ENV_POSTGRES_PASSWORD=$PG_ENV_POSTGRES_PASSWORD
EOF
exit 1
fi

cd /usr/local/src/gdtile
sed -e "s%<Parameter name='host'>127.0.0.1</Parameter>%<Parameter name='host'>$PG_PORT_5432_TCP_ADDR</Parameter>%" \
    -e "s%<Parameter name='user'>osm</Parameter>%<Parameter name='user'>$PG_ENV_POSTGRES_USER</Parameter>\n<Parameter name='password'>$PG_ENV_POSTGRES_PASSWORD</Parameter>%" \
    -e "s%<Parameter name='dbname'>osm</Parameter>%<Parameter name='dbname'>$PG_ENV_POSTGRES_DB</Parameter>%" \
    -i layers.mml
exec ./run-server.py
