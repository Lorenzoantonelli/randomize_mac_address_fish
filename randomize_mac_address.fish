function randomize_mac_address
    if ! type -q openssl
        echo "Error: openssl command not found"
        return 1
    end

    sudo -v
    if [ $status -ne 0 ]
        echo "Error: Failed to obtain sudo privileges"
        return 1
    end

    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
    
    if [ -z $argv[1] ]
        while true
            set macaddress (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
            sudo ifconfig en0 ether $macaddress
            if [ $status -eq 0 ]
                break
            end
        end
    else
        set macaddress $argv[1]
        if ! string match -r -q '([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})' $macaddress
            echo "Error: Invalid MAC address format"
            return 1
        end

        sudo ifconfig en0 ether $macaddress
        if [ $status -ne 0 ]
            echo "Error: Failed to set MAC address to $macaddress"
            return 1
        end
    end

    set -x -g macaddress $macaddress
    echo "Your new MAC address is $macaddress"
    sudo networksetup -setairportpower en0 off
    sudo networksetup -setairportpower en0 on
end
