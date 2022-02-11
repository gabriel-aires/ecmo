#!/sbin/openrc-run

name="ecmo"
description="Easy Configuration Management Orchestration"
supervisor="supervise-daemon"
command="/opt/ecmo/bin/ecmo"
output_log="/opt/ecmo/service.log"
error_log="/opt/ecmo/error.log"

start_pre() {
  export MODE SERVER_PORT SERVER_HOST DB_RETENTION SESSION_KEY SESSION_SECRET ALLOW_READ ALLOW_WRITE
}

depend() {
  after net localmount netmount
}
