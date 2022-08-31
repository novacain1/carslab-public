#!/bin/bash

driver=$(nmcli -t -m tabular -f general.driver dev show "${DEVICE_IFACE}")

if [[ "$2" == "up" && "${driver}" == "i40e" && -f /usr/sbin/ethtool ]]; then
  logger -s "99-i40e-debug triggered by ${2} on device ${DEVICE_IFACE}."
  ethtool -s ${DEVICE_IFACE} msglvl 0x0200
fi
