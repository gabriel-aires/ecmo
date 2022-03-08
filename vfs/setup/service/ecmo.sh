#!/sbin/openrc-run

name="ecmo"
description="Easy Configuration Management Orchestration"
supervisor="supervise-daemon"
command="/opt/ecmo/bin/ecmo"
output_log="/opt/ecmo/service.log"
error_log="/opt/ecmo/error.log"

start_pre() {
  export MODE SERVER_PORT SERVER_HOST DB_RETENTION SESSION_KEY SESSION_SECRET ALLOW_READ ALLOW_WRITE ACCURACY_LOAD ACCURACY_DISK ACCURACY_NET ACCURACY_MEM
}

depend() {
  after net localmount netmount
}
