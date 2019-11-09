+++
title = "Installing Nvidia drivers on Fedora"
date = "2019-11-09T14:12:40Z"
tags = ["linux","desktop","installation","drivers"]
categories = ["computing"]
+++

## The market

I have an Nvidia GeForce GTX 1080 Ti in my desktop, which runs Fedora 31.
Using the open source [Nouveau](https://nouveau.freedesktop.org/wiki/) drivers was easy, just install and go.
In search of optimal performance and power management, I decided to install the proprietary drivers.
The options were to use [rpmfusion](https://rpmfusion.org/Howto/NVIDIA), [negativo17](https://negativo17.org/nvidia-driver/), or the [Nvidia](https://www.nvidia.com/en-us/drivers/unix/) binaries.
Getting that working a finicky one indeed.
Be warned that changing from one of these options to another can require a system reinstall. 
Here's the solution I found which worked.

## negativo17

Start by removing any existing Nvidia drivers from the system

```shell
sudo dnf remove '*nvidia*'
```

Add the repository with 

```shell
sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
```

and install the drivers with

```shell
sudo dnf install --repo fedora-nvidia nvidia-driver akmod-nvidia nvidia-driver-libs.i686 nvidia-settings
```

Disable Nouveau by appending `rd.driver.blacklist=nouveau` to `GRUB_CMDLINE_LINUX` in `/etc/sysconfig/grub`.
For example, mine looks like

```
cat /etc/sysconfig/grub 
```
```
GRUB_TIMEOUT=15
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="quiet rd.driver.blacklist=nouveau"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true
```

That's it!
I didn't install CUDA, see [here](https://negativo17.org/nvidia-driver/) for instructions.
