#!/bin/bash

WORKER="manage.py celery -A HttpRunnerManager worker --loglevel=info"
BEAT="manage.py celery beat --loglevel=info"
FLOWER="manage.py celery flower"

WORKER_PID=worker.pid
BEAT_PID=celerybeat.pid
FLOWER_PID=flower.pid

WORKER_LOG=logs/celeryworker.log
BEAT_LOG=logs/celerybeat.log
FLOWER_LOG=logs/celeryflower.log


function start_check(){
    if [ `ps -ef | grep "$1" | grep -v "grep" | wc -l` == 0 ];then
        nohup python3 $1 > $2 2>&1 &
        if [ $# == 3 ];then
            echo -n $!>$3
        fi
    fi
}

function stop_kill
{
    if [ -f $1 ]; then
        pid=`cat $1`
        if [ -n "${pid}" ]; then
            kill $pid
        fi
        rm -f $1
    fi
}

function do_start(){
    start_check "$WORKER" $WORKER_LOG $WORKER_PID
    start_check "$BEAT" $BEAT_PID
    start_check "$FLOWER" $FLOWER_LOG $FLOWER_PID
    echo 'Services started'
}

function do_stop(){
    stop_kill $WORKER_PID
    stop_kill $BEAT_PID
    stop_kill $FLOWER_PID
    echo 'Services stoped'
}


function do_reload(){
    do_stop
    i=1
    while [ $i -le 120 ]
    do
        # validate service
        if [ `ps -ef | grep "$WORKER" | grep -v "grep" | wc -l` == 0 ] && [ `ps -ef | grep "$BEAT" | grep -v "grep" | wc -l` == 0 ] && [ `ps -ef | grep "$FLOWER" | grep -v "grep" | wc -l` == 0 ];then
            do_start
            break
        fi
        let i++
        sleep 0.5
    done
}


function usage
{
    echo "Usage: $0 { start | stop | restart }"
}

if [ $# != 1 ]; then
    usage
    exit 0
fi

case "$1" in
    "start")
        do_start
    ;;
    "stop")
        do_stop
    ;;
    "restart")
        do_reload
    ;;
    *)
    usage
    exit 0
    ;;
esac