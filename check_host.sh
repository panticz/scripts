#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
BOLD="\e[1m"
CLEAR="\e[0m"
IFS=$(echo -en "\n\b")


function title() {
    echo -e "\n${BOLD}${BLUE}${1}${CLEAR}"
}

function state_ok() {
    echo -en "${GREEN}${1:-OK}${CLEAR}"
}

function state_err() {
    echo -en "${RED}${1:-ERROR}${CLEAR}"
}

function try_sudo() {
    CMD=${1}

    timeout 1 sudo -n ${CMD} > /dev/null 2>&1
    if [[ $? -eq 0 ]] || [[ $(id -u) -eq 0 ]]; then
        return 0
    else
        echo "sudo ${CMD} not allowed"
        return 1
    fi
}


title "HOST"
printf "%-35s\t: %s\n" "Hostname" "$(hostname -f)"
printf "%-35s\t: %s\n" "IP(s)" "$(hostname -I)"
printf "%-35s\t: %s\n" "Load" "$(cat /proc/loadavg | cut -d" " -f 1-3)"


title "BACKUP"
BACKUP_USAGE=$(df --output=pcent /backup | tail -1 | sed 's/[^0-9]*//g')
printf "%-35s\t: %s\n" "Backup disk usage" "$([ ${BACKUP_USAGE} -gt 80 ] && state_err "${BACKUP_USAGE}%" || state_ok "${BACKUP_USAGE}%")"

BACKUP_OUT=$(du -h -d 0 -t -1M /backup/*/daily.*/ | sort -V -k 2)
BACKUP_ERR_COUNT=$(echo "${BACKUP_OUT}" | wc -l)
printf "%-35s\t: %s\n" "Empty backup directories" "$([ ${BACKUP_ERR_COUNT} -eq 0 ] && state_ok || state_err "${BACKUP_ERR_COUNT}x ERROR" && echo -e "\n${BACKUP_OUT}" | head)"


title "RAID"
for MD in $(cat /proc/mdstat | grep md); do
    printf "%-35s\t: %s\n" "${MD}" "$([[ "${MD}" =~ active ]] && state_ok || state_err)"
done


title "DISK (SMART)"
if try_sudo /usr/sbin/smartctl; then
    for DISK in $(ls /dev/sd?); do
        SMART_OUT=$(sudo /usr/sbin/smartctl -H ${DISK})
        printf "%-35s\t: %s\n" "${DISK}" "$([ $? ] && state_ok || state_err)"
    done
fi
