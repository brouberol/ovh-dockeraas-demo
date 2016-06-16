#!/bin/bash

set -e

echo $1
if [[ "$1" = "api" || -z $1 ]];then

    export G_WORKERS=${G_WORKERS:=5}
    export G_THREADS=${G_THREADS:=1}
    export G_MAX_REQUESTS=${G_MAX_REQUESTS:=1000}
    export G_MAX_REQUESTS_JITTER=${G_MAX_REQUESTS_JITTER:=20}
    export G_BACKLOG=${G_BACKLOG:=5}
    export G_TIMEOUT=${G_TIMEOUT:=300}
    export G_GRACEFUL_TIMEOUT=${G_GRACEFUL_TIMEOUT:=300}

    echo "Starting API"
    exec gunicorn \
        --bind 0.0.0.0:${API_PORT:=5000} \
        --workers $G_WORKERS \
        --threads $G_THREADS \
        --backlog $G_BACKLOG \
        --timeout $G_TIMEOUT \
        --graceful-timeout $G_GRACEFUL_TIMEOUT \
        --access-logfile - \
        --access-logformat '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s %(L)ss "%(f)s" "%(a)s"' \
        --max-requests $G_MAX_REQUESTS \
        --max-requests-jitter $G_MAX_REQUESTS_JITTER \
        app:app

elif [ "$1" = "celery_worker" ];then

    export CELERY_WORKER_MAX_TASKS=${CELERY_WORKER_MAX_TASKS:=1000}
    export CELERY_QUEUES=${CELERY_QUEUES:=celery}
    export C_FORCE_ROOT="true"

    echo "Starting celery worker"
    exec celery worker \
        -A demo.tasks \
        -Q $CELERY_QUEUES \
        --maxtasksperchild=$CELERY_WORKER_MAX_TASKS \
        --loglevel=INFO

else

    echo "Wrong argument : $1"

fi

