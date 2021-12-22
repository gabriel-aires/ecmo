#!/sbin/openrc-run

name="os-probe"
description="Dashboard for system metrics and configuration management"
supervisor="supervise-daemon"
command="/opt/os-probe/bin/os-probe"
output_log="/opt/os-probe/service.log"
error_log="/opt/os-probe/error.log"

depend() {
  after net localmount netmount
}
