# randomize_mac_address_fish
The **randomize_mac_address** function is a simple fish shell script that allows you to set a random MAC address for your Wi-Fi connection on macOS.

> **Warning**
> 
> The MAC address change lasts only until the device is rebooted.


## Installation
* Clone the repo:
```bash
git clone https://github.com/Lorenzoantonelli/randomize_mac_address_fish.git
```
 * Copy the **randomize_mac_address.fish** in fish's functions folder:
```bash
cd randomize_mac_address_fish
cp randomize_mac_address.fish ~/.config/fish/functions/
```
  
## Usage
From fish shell simply run the command:
```bash
randomize_mac_address
```

You can also specify a MAC address to use instead of a random one:
```bash
randomize_mac_address [macaddress]
```



## How to restore the original MAC address
If you want to restore your original MAC address after using the randomize_mac_address function, you can simply reboot your device.
