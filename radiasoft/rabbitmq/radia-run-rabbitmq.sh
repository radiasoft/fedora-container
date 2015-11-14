#!/bin/bash
set -e
. ~/.bashrc
is config file there

radia-run.env sets variables for radia-run which includes

cat > EOF
[{rabbit, [{loopback_users, []}]}].

export HOME=$RADIASOFT_GUEST_DIR
export RABBITMQ_CONFIG_FILE=$GUEST_DIR/rabbitmq
export RABBITMQ_LOG_BASE=$GUEST_DIR/log
export RABBITMQ_MNESIA_BASE=$GUEST_DIR/mnesia
cd "$GUEST_DIR"
exec /usr/lib/rabbitmq/bin/rabbitmq-server "$@"

PID_FILE=/var/run/rabbitmq/pid
INIT_LOG_DIR=/var/log/rabbitmq
$CONTROL rotate_logs ${ROTATE_SUFFIX}

                if [ -n "$LOCK_FILE" ] ; then
                    touch $LOCK_FILE
                fi
                remove_pid
                echo FAILED - check ${INIT_LOG_DIR}/startup_\{log, _err\}
                RETVAL=1

ensure_pid_dir () {
    PID_DIR=`dirname ${PID_FILE}`
    if [ ! -d ${PID_DIR} ] ; then
        mkdir -p ${PID_DIR}
        chown -R ${USER}:${USER} ${PID_DIR}
        chmod 755 ${PID_DIR}
    fi
}


        ensure_pid_dir
        set +e
        RABBITMQ_PID_FILE=$PID_FILE $START_PROG $DAEMON \
            > "${INIT_LOG_DIR}/startup_log" \
            2> "${INIT_LOG_DIR}/startup_err" \
            0<&- &
        $CONTROL wait $PID_FILE >/dev/null 2>&1

        $CONTROL stop ${PID_FILE} > ${INIT_LOG_DIR}/shutdown_log 2> ${INIT_LOG_DIR}/shutdown_err





--hostname $service
--name $service

: ${host_user:=vagrant}
: ${guest_user:=$host_user}
: ${host_port:=$guest_port}
: ${host_name:=$container_name}
: ${host_dir:=/var/lib/$container_name}
: ${guest_dir:=/vagrant}

options=(
    --name "$container_name"
    --hostname "$host_name"
)
if [[ $host_user ]]; then
    options+=( -u $guest_user )
for l in "${links[@]}"; do
    options+=(--link $l)
done

env

bash_cmd='SIREPO_SERVER_JOB_QUEUE=Celery SIREPO_CELERY_TASKS_BROKER_URL=amqp://guest@rabbitmq// sirepo service http --port $guest_port --db-dir $guest_dir'

build radiasoft/rabbitmq with vagrant
/vagrant/CONF_FILE in guest_dir

user running rabbitmq is vagrant, should just work

# no need for this hosstname RABBITMQ_NODENAME=rabbitmq

RABBITMQ_MNESIA_BASEDefaults to /var/lib/rabbitmq/mnesia. Set this to the directory where Mnesia database files should be placed.

RABBITMQ_LOG_BASE
Defaults to /var/log/rabbitmq. Log files generated by the server will be placed in this directory.

RABBITMQ_CONFIG_FILE=/vagrant/

cmd+=( $(eval echo "$bash_cmd") )
[[ -r ~/.bashrc ]] && . ~/.bashrc;


host_user=vagrant
guest_user=vagrant

if [[ ! -d $host_dir ]]; then
    mkdir -p $host_dir
    # Must be the same as host_user
    chown $host_user:$host_user $host_dir
fi


RABBITMQ_NODENAME
guest_dir=/var/lib/rabbitmq
symlink /var/lib/rabbitmq to /vagrant for easy. Symlink to /vagrant/

symlink /etc/rabbitmq to /vagrant

# User is vagrant 1000
rabbitmq.config

config file(s) : /etc/rabbitmq/rabbitmq.config


delete env
unset starting rabbit

#RABBITMQ_SASL_LOGS=-
#RABBITMQ_LOGS=-

RUN echo '[{rabbit, [{loopback_users, []}]}].' > /etc/rabbitmq/rabbitmq.config
# /usr/sbin/rabbitmq-server has some irritating behavior, and only exists to "su - rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server ..."
ENV PATH /usr/lib/rabbitmq/bin:$PATH

VOLUME /var/lib/rabbitmq

# add a symlink to the .erlang.cookie in /root so we can "docker exec rabbitmqctl ..." without gosu
RUN ln -sf /var/lib/rabbitmq/.erlang.cookie /root/
RUN apt-get update && apt-get install -y rabbitmq-server=$RABBITMQ_VERSION --no-install-recommends && rm -rf /var/lib/apt/lists/*

# get logs to stdout (thanks @dumbbell for pushing this upstream! :D)
ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-
# https://github.com/rabbitmq/rabbitmq-server/commit/53af45bf9a162dec849407d114041aad3d84feaf


########
RABBITMQ_HOME

$RABBITMQ_MNESIA_DIR.pid
RABBITMQ_CONFIG_FILE${install_prefix}/etc/rabbitmq/rabbitmq

RABBITMQ_MNESIA_BASE=/vagrant/mnesia
# logs are for each node
RABBITMQ_LOG_BASE=/vagrant/log



????
ENV RABBITMQ_VERSION 3.5.6-1



https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm



-v /vagrant

-u vagrant rabbitmq-server


On Unix systems, the cookie will be typically located in /var/lib/rabbitmq/.erlang.cookie or $HOME/.erlang.cookie.







# docker run -i -t -v $PWD/run:/vagrant -p 8000:8000 --link rabbit:rabbit -u vagrant radiasoft/sirepo:20151111.232429 /bin/bash -i -c 'SIREPO_SERVER_JOB_QUEUE=Celery SIREPO_CELERY_TASKS_BROKER_URL=amqp://guest@rabbit// sirepo service http --port 8000 --db-dir /vagrant'

# docker run --rm --link rabbit:rabbit --name celery -v $PWD/run:/vagrant -u vagrant radiasoft/sirepo:20151111.232429 /bin/bash -i -c 'SIREPO_CELERY_TASKS_BROKER_URL=amqp://guest@$RABBIT_PORT_5672_TCP_ADDR// celery worker -A sirepo.celery_tasks -l info'



# docker run --rm --hostname rabbit --name rabbit -p 5672:5672 rabbitmq