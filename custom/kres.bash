export NEXUS_USERNAME="trumans"
export NEXUS_PASSWORD="smub_kaur-TEAF0sheb"
export ORG_GRADLE_PROJECT_nexusUsername=${NEXUS_USERNAME}
export ORG_GRADLE_PROJECT_nexusPassword=${NEXUS_PASSWORD}

ssh-add ~/.ssh/id_ed25519

function get-us-gov-ip-ranges {
  curl -s 'https://ip-ranges.amazonaws.com/ip-ranges.json' | jq '.prefixes[] | select(.region | startswith("us-gov")) .ip_prefix' | sort -uV
}
function get-vpn-assigned-local-ip {
  ifconfig | egrep -m1 "inet 10.(255|204)" | cut -d " " -f2
}
function kr-vpn-forwarding {
  case $1 in
  activate)
    assigned_ip=${2:-$(get-vpn-assigned-local-ip)}
    if [ -z "$assigned_ip" ]; then
      echo "Error: no VPN-assigned local IP found. Are you connected to the VPN?"
      return
    fi
    get-us-gov-ip-ranges | xargs -L1 -I'{}' sudo route add "{}" "$assigned_ip"
    return
    ;;
  deactivate)
    assigned_ip=${2:-$(get-vpn-assigned-local-ip)}
    if [ -z "$assigned_ip" ]; then
      echo "Error: no VPN-assigned local IP found. Are you connected to the VPN?"
      return
    fi
    get-us-gov-ip-ranges | xargs -L1 -I'{}' sudo route delete "{}" "$assigned_ip"
    return
    ;;
  *)
    echo "kr-vpn-forwarding [activate|deactivate] <assigned-local-ip>"
    return
    ;;
  esac
}


function kr-zero-proxy-start {
  kr-zero-proxy --action=start
}

function kr-zero-proxy-env {
  kr-zero-proxy --action=env
}

