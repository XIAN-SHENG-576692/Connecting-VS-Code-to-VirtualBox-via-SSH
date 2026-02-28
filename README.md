# Connecting VS Code to VirtualBox via SSH

This guide demonstrates how to use the **VS Code Remote - SSH** extension to develop within a VirtualBox virtual machine.

---

## Prerequisites

1.  **Install VirtualBox**: Download it from the [official Oracle website](https://www.virtualbox.org/wiki/Downloads).
2.  **Prepare a Linux ISO**: 
    * It is highly recommended to use a **glibc-based** Linux distribution (e.g., Debian, Ubuntu, CentOS) for the best compatibility with VS Code.
    * For more details, refer to the:
        * [VS Code System Requirements](https://code.visualstudio.com/docs/supporting/requirements)
        * [Remote Development Overview](https://code.visualstudio.com/docs/remote/remote-overview)
        * [Remote Development FAQ](https://code.visualstudio.com/docs/remote/faq)
    * *Personal recommendation: Debian.*

---

## Setup Instructions

### 1. Configure VirtualBox Networking
To enable SSH access, set up Port Forwarding:
* Go to **Settings > Network**.
* Attached to: **NAT**.
* Click **Advanced > Port Forwarding** and add a new rule:
    * **Protocol**: `TCP`
    * **Host Port**: `[Choose an arbitrary port, e.g., 2222]`
    * **Guest Port**: `22` (Default SSH port)

### 2. VM Installation & SSH Key Generation
* Start the VM and complete the Linux installation.
* On your **Host machine**, generate an SSH key pair:
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```

### 3. Mount Shared Folders
To mount a VirtualBox shared folder, run the following inside the VM:
```bash
sudo mount -t vboxsf <Folder_Name_from_Settings> <Mount_Path>
```

### 4. Run Configuration Scripts
Execute the provided scripts within the shared folder to automate the environment setup:
- **Install Dependencies**: Install `sudo` and `podman`.
- `vbox_permanent_shares.sh`: Configures automounting for shared folders on boot.
- `setup_sshd.sh`: Configures SSH daemon settings.
- `sshd_add_pub_key.sh`: Adds your public key to the VM's authorized keys.
- `setup_podman.sh`: Configures Podman for use with VS Code.

### 5. Configure Host SSH Access
Edit the `~/.ssh/config` file on your **Host machine**:
```
Host <Any_Name>
    HostName 127.0.0.1
    User <VM_Username>
    Port <Your_Port_Forwarding_Host_Port>
    IdentityFile <Path_to_Private_Key>
```

### 6. Configure VS Code for Podman
In your Host's `settings.json`, set the Docker path to use Podman:
```json
"dev.containers.dockerPath": "podman"
```

## How to Use
1. Open VS Code.
2. Run the command `Remote-SSH: Connect to Host...` from the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`).
3. Select the Host you configured in step 5.
4. **Done!** You are now connected to your VM.
> [!TIP]
> Developing directly within a VirtualBox shared folder may lead to unexpected write permission issues. It is highly recommended to keep your source code in the VM's local filesystem for better performance and reliability.
