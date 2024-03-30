# **Connect USB Devices to WSL**

# Introduction

This guide will help you connect a USB device to a Linux distribution running on WSL 2 using the usbipd-win project. For more detailed information, you can also refer to the official guide by Microsoft [here](https://learn.microsoft.com/en-us/windows/wsl/connect-usb).

# Prerequisites

Make sure you have:

- An up-to-date Windows 10 or 11
- WSL installed and set up to WSL 2.

# Install usbipd-win Project

1. Download the latest release of usbipd-win from [here](https://github.com/dorssel/usbipd-win/releases).
2. Run the installer and follow the on-screen instructions.

# Attach a USB Device

1. List all connected USB devices.
    
    ```powershell
    usbipd list
    ```
    
2. Share the USB device to be attached to WSL.
    
    ```powershell
    usbipd bind --busid <busid>
    ```
    
3. Attach the USB device to WSL.
    
    ```powershell
    usbipd attach --wsl --busid <busid>
    ```
    
4. Check the attached USB device in WSL.
    
    ```bash
    lsusb
    ```
    

That's it! You've connected a USB device to your WSL Linux distribution. For further details and troubleshooting, refer to the official [Microsoft guide](https://learn.microsoft.com/en-us/windows/wsl/connect-usb).

Once done, you can detach the USB device

```powershell
usbipd detach --busid <busid>
```
