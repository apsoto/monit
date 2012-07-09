#!/bin/sh

### BEGIN INIT INFO
# Provides:          monit
# Required-Start:    $remote_fs
# Required-Stop:     $remote_fs
# Should-Start:      $all
# Should-Stop:       $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: service and resource monitoring daemon
# Description:       monit is a utility for managing and monitoring
#                    processes, programs, files, directories and filesystems
#                    on a Unix system. Monit conducts automatic maintenance
#                    and repair and can execute meaningful causal actions
#                    in error situations.
### END INIT INFO

set -e

. /lib/lsb/init-functions

DAEMON=/usr/bin/monit
CONFIG="/etc/monit/monitrc"
DELAY="/etc/monit/monit_delay"
NAME=monit
DESC="daemon monitor"
MONIT_OPTS=
PID="/var/run/$NAME.pid"

# Check if DAEMON binary exist
[ -f $DAEMON ] || exit 0

[ -f "/etc/default/$NAME" ] && . /etc/default/$NAME

# For backward compatibility, handle startup variable:
if [ -n "$startup" ]
then
  if [ "$1" = "start" ]
  then
    printf "\tPlease, use START variable in /etc/default/monit\n"
    printf "\tto enable/disable $NAME startup.\n"
  fi

  if [ -z "$START" ] && [ "$startup" -eq 1 ]
  then
    START="yes"
  fi
fi

# For backward compatibility, handle CHECK_INTERVALS variable:
if [ -n "$CHECK_INTERVALS" ]
then
  if [ "$1" = "start" ]
  then
    printf "\tPlease, use MONIT_OPTS variable in /etc/default/monit\n"
    printf "\tto specify command line options for $NAME.\n"
  fi

  MONIT_OPTS="$MONIT_OPTS -d $CHECK_INTERVALS"
fi

MONIT_OPTS="-c $CONFIG $MONIT_OPTS"

monit_not_configured () {
  if [ "$1" != "stop" ]
  then
    printf "\tplease configure $NAME and then edit /etc/default/$NAME\n"
    printf "\tand set the \"START\" variable to \"yes\" in order to allow\n"
    printf "\t$NAME to start\n"
  fi
  exit 0
}

monit_check_config () {
  # Check for emtpy config.
  if [ "`grep -s -v \"^#\" $CONFIG`" = "" ]
  then
    echo "empty config, please edit $CONFIG."
    exit 0
  fi
}

monit_check_perms () {
  # Check the permission on configfile.
  # The permission must not have more than -rwx------ (0700) permissions.

  # Skip checking, fix perms instead.
  /bin/chmod go-rwx $CONFIG
}

monit_delayed_monitoring () {
  if [ -f $DELAY ]
  then
    printf "Warning: Please, set start delay for $NAME in config file\n"
    printf "         and delete $DELAY file.\n"

    if [ ! -x $DELAY ]
    then
      printf "Warning: A delayed start file exists ($DELAY)\n"
      printf "         but it is not executable.\n"
    else
      $DELAY &
    fi
  fi
}

monit_checks () {
  # Check if START variable is set to "yes", if not we exit.
  if [ "$START" != "yes" ]
  then
    monit_not_configured $1
  fi
  # Check for emtpy configfile
  monit_check_config
  # Check permissions of configfile
  monit_check_perms
}

case "$1" in
  start)
    log_daemon_msg "Starting $DESC" "$NAME"
    monit_checks $1
    if start-stop-daemon --start --quiet --oknodo \
                         --pidfile $PID --exec $DAEMON \
                         -- $MONIT_OPTS
    then
      log_end_msg 0
    else
      log_end_msg 1
    fi
    monit_delayed_monitoring
    ;;
  stop)
    log_daemon_msg "Stopping $DESC" "$NAME"
    if start-stop-daemon --retry TERM/5/KILL/5 --oknodo --stop --quiet \
                         --pidfile $PID --exec $DAEMON
    then
      log_end_msg 0
    else
      log_end_msg 1
    fi
    ;;
  reload)
    log_daemon_msg "Reloading $DESC configuration" "$NAME"
    if start-stop-daemon --stop --signal HUP --quiet \
                                --oknodo --pidfile $PID \
                                --exec $DAEMON -- $MONIT_OPTS
    then
      log_end_msg 0
    else
      log_end_msg 1
	fi
    ;;
  restart|force-reload)
    $0 stop
    $0 start
    ;;
  syntax)
    $DAEMON $MONIT_OPTS -t
    ;;
  status)
    status_of_proc -p $PID $DAEMON $NAME
    ;;
  *)
    log_action_msg "Usage: /etc/init.d/$NAME {start|stop|reload|restart|force-reload|syntax|status}"
    ;;
esac

exit 0