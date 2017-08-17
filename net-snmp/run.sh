#!/bin/bash

(
    . /etc/sysconfig/snmpd
    if test "$WAIT_FOR_CONFIGURATION" == 1; then
        systemd-notify --ready
        exec sleep 9999d
    fi
)

(
    OPTIONS="-Lsd"
    . /etc/sysconfig/snmptrapd
    unset NOTIFY_SOCKET
    exec /usr/sbin/snmptrapd $OPTIONS -f
) &

OPTIONS="-LS0-6d"
. /etc/sysconfig/snmpd
exec /usr/sbin/snmpd $OPTIONS -f
