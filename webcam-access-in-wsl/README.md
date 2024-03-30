# **Setting Up Webcam Access in Windows Subsystem for Linux (WSL)**

# **Introduction**

Webcam access in Windows Subsystem for Linux (WSL) requires additional setup steps due to the lack of drivers in the default WSL kernel. In this guide, we'll walk through the process of setting up webcam access in Windows Subsystem for Linux (WSL) by building a new kernel with necessary drivers. 

# **Overview**

To enable webcam access in Windows Subsystem for Linux (WSL), we will follow these steps:

1. **Install Required Packages for Building Kernel:** Update the package list, upgrade existing packages, and install necessary dependencies for building the custom kernel.
2. **Download and Configure Custom Kernel:** Clone the WSL2 Linux kernel repository from the Microsoft repository, select the appropriate kernel version, copy the kernel configuration from the running system, and configure the kernel to include USB camera support using **`make menuconfig`**.
3. **Build Custom Kernel:** Build the custom kernel and its modules using the **`make`** command with multiple threads to speed up the process.
4. **Install Custom Kernel:** Install the custom kernel and modules, then copy the kernel image to a Windows-accessible directory.
5. **Configure WSL to Use Custom Kernel:** Specify the path to the custom kernel in the **`.wslconfig`** file located in the user's Windows profile folder.
6. **Configure USB Passthrough:** Configure USB passthrough to enable access to USB devices within the WSL environment.
7. **Test System Configuration:** Verify the functionality of the new kernel, USB detection, presence of video devices, and webcam view accessibility within the WSL environment.

# **Steps**

Before we begin, it's important to note that steps 1 to 4 and 7 will be executed within the Windows Subsystem for Linux (WSL), while steps 5 and 6 will be performed on the Windows side.

## **Step 1: Install Required Packages for Building Kernel**

First, let's update the package list, upgrade existing packages, and install necessary dependencies for building the custom kernel.

```bash
# Update package list
sudo apt update

# Upgrade existing packages
sudo apt upgrade -y

# Install necessary dependencies for building the custom kernel
sudo apt install -y build-essential flex bison libgtk2.0-dev libelf-dev libncurses-dev autoconf libudev-dev libtool zip unzip v4l-utils libssl-dev python3-pip cmake git iputils-ping net-tools dwarves
```

## **Step 2: Download and Configure Custom Kernel**

Now, let's clone the WSL2 Linux kernel repository provided by Microsoft and configure the custom kernel to include USB camera support.

```bash
# Dynamically retrieve kernel version from uname -r output
VERSION=$(uname -r | cut -d '-' -f1)

# Create directory for kernel source code
sudo mkdir /usr/src

# Navigate to kernel source code directory
cd /usr/src

# Clone WSL2 Linux kernel repository from Microsoft
sudo git clone -b linux-msft-wsl-${VERSION} https://github.com/microsoft/WSL2-Linux-Kernel.git ${VERSION}-microsoft-standard

# Open the relevant directory
cd ${VERSION}-microsoft-standard
```

Once cloned, we will proceed to configure the custom kernel to include USB camera support:

```bash
# Copy kernel configuration from running system
sudo cp /proc/config.gz config.gz

# Unzip kernel configuration
sudo gunzip config.gz

# Rename kernel configuration file
sudo mv config .config

# Configure kernel options including USB camera support
sudo make menuconfig
```

In the **`menuconfig`** interface, navigate to the following options:

- Device Drivers -> Multimedia support -> Filter media drivers
- Device Drivers -> Multimedia support -> Media device types -> Cameras and video grabbers
- Device Drivers -> Multimedia support -> Video4Linux options -> V4L2 sub-device userspace API
- Device Drivers -> Multimedia support -> Media drivers -> Media USB Adapters -> USB Video Class (UVC)
- Device Drivers -> Multimedia support -> Media drivers -> Media USB Adapters -> UVC input events device support
- Device Drivers -> Multimedia support -> Media drivers -> Media USB Adapters -> GSPCA based webcams

## **Step 3: Build Custom Kernel**

Next, let's build the custom kernel and its modules.

```bash
# Build kernel with multiple threads for faster compilation
sudo make -j$(nproc)

# Install kernel modules
sudo make modules_install -j$(nproc)

# Install custom kernel
sudo make install -j$(nproc)
```

## **Step 4: Install Custom Kernel**

After building the custom kernel, we need to install it and copy the kernel image to a Windows-accessible directory.

```bash
# Create a Sources directory and copy kernel image to Windows-accessible directory
mkdir /mnt/c/Sources/
sudo cp -rf vmlinux /mnt/c/Sources/
```

## **Step 5: Configure WSL to Use Custom Kernel**

To use the custom kernel with WSL, we need to specify its path in the **`.wslconfig`** file located in the user's Windows profile folder.

Open or create the **`.wslconfig`** file, and add the following lines:

```csharp
[wsl2]
kernel=C:\\Sources\\vmlinux
```

Replace **`C:\\Sources\\vmlinux`** with the actual path to the **`vmlinux`** file in the Windows-accessible directory where you copied it.

Once the changes are saved, restart WSL by running **`wsl --shutdown`** in PowerShell as an administrator to apply the new kernel settings.

## **Step 6: Configure USB Passthrough**

To use your USB devices connected to your Windows PC in your WSL environment you need to pass your USB devices to WSL. 

Configuring USB passthrough allows seamless access to USB devices from within the WSL environment.

For configuring USB passthrough in Windows Subsystem for Linux (WSL), you can follow the instructions provided in [connect-usb-devices-to-wsl](../connect-usb-devices-to-wsl) folder or use the [Microsoft documentation on USB passthrough](https://learn.microsoft.com/en-us/windows/wsl/connect-usb) for a comprehensive guide.


## **Step 7: Test System Configuration**

In this step, we'll perform various tests to ensure that our system configuration is functioning as expected after setting up webcam access in Windows Subsystem for Linux (WSL).

### **Testing:**

1. **Test if the New Kernel is Working:**
    - Open your WSL terminal.
    - Run the following command to check the kernel version:
        
        ```bash
        uname -r
        ```
        
    - **Expected Result:** The output should display the custom kernel version with + at the end. 
2. **Test if `lsusb` Shows the USB Device:**
    - Plug in your USB webcam device.
    - Run the following command to list USB devices:
        
        ```bash
        lsusb
        ```
        
    - **Expected Result:** The output should include your USB webcam device.
3. **Test if There is a Video Device:**
    - Run the following command to list video devices:
        
        ```bash
        ls /dev/video*
        ```
        
    - **Expected Result:** The output should show at least one video device, representing your webcam.
4. **Test if You Can Get the View:**
    - Install a webcam viewing application such as **`cheese`** by running:
        
        ```bash
        sudo apt install cheese
        ```
        
    - Launch **`cheese`** by typing:
        
        ```bash
        cheese
        ```
        
    - **Expected Result:** The **`cheese`** application should display the webcam view without any issues.

By following these testing procedures, you can ensure that your system is properly configured to access and utilize your webcam within the WSL environment.

# **Conclusion**

By following these steps, you have successfully set up webcam access in Windows Subsystem for Linux (WSL) and configured USB passthrough. This allows you to utilize your webcam within your WSL environment and access USB devices seamlessly. Enjoy enhanced functionality and productivity in your WSL workflows!
