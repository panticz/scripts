#!/bin/bash

export SERVER_ID=@option.vm@

# search for VM by name
if [ ${#SERVER_ID} -ne 36 ]; then
    RESULT="$(openstack server list --all --name ${SERVER_ID})"
    if [ $(echo "${RESULT}" | wc -l) -eq 5 ]; then
        SERVER_ID=$(echo "${RESULT}" | tail -2 | head -1 | cut -d " " -f2)
    else
        echo "Found several VMs, please choose one from:"
        echo "${RESULT}"
        exit 0
    fi
fi

echo -e "VM:"
openstack server show -c name -c id -c addresses -c OS-EXT-SRV-ATTR:host -c status ${SERVER_ID}

echo -e "\nProject:"
PROJECT_ID=$(openstack server show -c project_id -f value ${SERVER_ID})
openstack project show -c id -c name -c description ${PROJECT_ID}

echo -e "\nDomain:"
DOMAIN_ID=$(openstack project show -c domain_id -f value ${PROJECT_ID})
openstack domain show -c id -c name -c description ${DOMAIN_ID}

echo -e "\nServer:"
openstack server show ${SERVER_ID}

echo -e "\nConsole:"
openstack console url show ${SERVER_ID}

echo -e "\nMigration(s):"
nova migration-list --instance-uuid ${SERVER_ID}

echo -e "\nVM Port(s):"
#nova interface-list ${SERVER_ID}
openstack port list --server ${SERVER_ID} --long
PORT_IDS=$(openstack port list --server ${SERVER_ID} -c id -f value)

for PORT_ID in ${PORT_IDS}; do
    NETWORK_ID=$(openstack port show ${PORT_ID} -c network_id -f value)
    NETWORK_NAME=$(openstack network show ${NETWORK_ID} -c name -f value)

    echo -e "\n+++++ Start network ${NETWORK_NAME} +++++"
    
    echo -e "\nNetwork:"
    openstack network show ${NETWORK_ID}
    
    echo -e "\nSubnet:"
    SUBNET_ID=$(openstack subnet list --network ${NETWORK_ID} -c ID -f value)
    openstack subnet show ${SUBNET_ID}
    
    echo -e "\nNetwork ports:"
    openstack port list --network ${NETWORK_ID}
    
    echo -e "\nSecurity group(s):"
    #SECURITY_GROUP_IDS="$(openstack port show ${PORT_ID} -c security_group_ids -f json | jq -r .security_group_ids[])"
    # workaround for old OSC
    SECURITY_GROUP_IDS="$(openstack port show ${PORT_ID} -c security_group_ids -f json | jq -r .security_group_ids | tr ',' '\n')"
    for SECURITY_GROUP_ID in ${SECURITY_GROUP_IDS}; do
        openstack security group show ${SECURITY_GROUP_ID}
    done
    
    echo -e "\nRouter:"
    ROUTER_DEVICE_ID=$(openstack port list --network ${NETWORK_ID} --device-owner network:ha_router_replicated_interface -c device_id -f value)
    if [ ! -z ${ROUTER_DEVICE_ID} ]; then
        ROUTER_HOSTS=$(openstack port list --device-id ${ROUTER_DEVICE_ID} --device-owner network:router_ha_interface -c binding_host_id -f value --sort-column binding_host_id)
        for ROUTER_HOST in ${ROUTER_HOSTS}; do
            echo "ssh -t ${ROUTER_HOST} ip netns exec qrouter-${ROUTER_DEVICE_ID} bash"
            ssh ${ROUTER_HOST} ip netns exec qrouter-${ROUTER_DEVICE_ID} ip a | sed -n '/BROADCAST/,$p' | egrep -v "inet6|valid_lft"
            echo
        done
    fi

    echo -e "\nDHCP/DNS:"
    DHCP_HOSTS=$(openstack port list --network ${NETWORK_ID} --device-owner network:dhcp -c binding_host_id -f value --sort-column binding_host_id)
    for DHCP_HOST in ${DHCP_HOSTS}; do
        echo "ssh -t ${DHCP_HOST} ip netns exec qdhcp-${NETWORK_ID} bash"
        ssh ${DHCP_HOST} ip netns exec qdhcp-${NETWORK_ID} ip a | sed -n '/BROADCAST/,$p' | egrep -v "inet6|valid_lft"
        echo
    done
        
    echo "+++++ END network ${NETWORK_NAME} +++++"
done
