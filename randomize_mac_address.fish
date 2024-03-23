function randomize_mac_address
    if ! type -q openssl
        echo "Error: openssl command not found" >&2
        return 1
    end

    sudo -v
    if [ $status -ne 0 ]
        echo "Error: Failed to obtain sudo privileges" >&2
        return 1
    end

    # sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
    sudo networksetup -setnetworkserviceenabled Wi-Fi off
    sudo networksetup -setnetworkserviceenabled Wi-Fi on
    
    if [ -z $argv[1] ]
        set count 0
        while true
            set macaddress (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
            sudo ifconfig en0 ether $macaddress 2>/dev/null
            if [ $status -eq 0 ]
                break
            else
                set count (math $count + 1)
                if [ $count -eq 10 ]
                    echo "Error: Too many failed attempts to set MAC address" >&2
                    return 1
                end
            end
        end
    else
        set macaddress $argv[1]
        if ! string match -r -q '([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})' $macaddress
            if string match -r -q '([0-9A-Fa-f]{2}){6}' $macaddress
                set macaddress (echo $macaddress | sed 's/\(..\)/\1:/g; s/.$//')
            else
                echo "Error: Invalid MAC address format" >&2
                return 1
            end
        end

        sudo ifconfig en0 ether $macaddress 
        if [ $status -ne 0 ]
            echo "Error: Failed to set MAC address to $macaddress" >&2
            return 1
        end
    end

    set -x -g macaddress $macaddress
    echo "Your new MAC address is $macaddress"
    
    sudo networksetup -setairportpower en0 off
    sudo networksetup -setairportpower en0 on
end
