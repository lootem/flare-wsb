> [!WARNING]
> This project is not affiliated with Microsoft, Mandiant/Google, or [FLARE-VM](https://github.com/mandiant/flare-vm).

# FLARE-WSB

This project leverages undocumented techniques to modify Microsoft's [Windows Sandbox (WSB)](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/) base image and replace it with a FLARE VM.

## Why?

To quote one of Microsoft's suggested use cases for WSB:
> **Running Untrusted Applications:** Mitigate security risks by opening untrusted applications or files, such as email attachments in WSB. Improve your safety and security by opening a sandbox with networking disabled and mapping the folder with the application or file you want to open to the sandbox in read-only mode. 

The only problem is that if you want to do *in-depth* analysis on an untrusted application, the sandbox container is so ephemeral that you would need to re-install non-portable tools each time you start it. This can be automated, but depending on which tools you need it can be time-consuming, tedious, and often require internet access (not ideal when analyzing malware!)*

The FLARE-VM project is designed to run on a Windows virtual machine image and allows analysts to easily setup and maintain tools for reverse engineering and malware analysis on a persistent image. By leveraging the [WSB CLI](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-cli) and some creative techniques, we can install FLARE VM within the Sandbox and ensure it persists by saving tools and relevant files to the WSB container's base layer.

> [!NOTE]
> *Per [Microsoft Documentation](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-configure-using-wsb-file): when WSB networking is enabled it "can expose untrusted applications to the internal network"!

## How?

At a high-level, the `install.ps1` script does the following:

1. Identifies the Windows Sandbox base layer location on the host
2. Shares the base layer with the Windows Sandbox
3. Acquires the WDAGUtilityAccount password using `SandboxCommon.dll` to share it with the FLARE installer
4. Starts the FLARE VM installer*
5. Upon confirmation, copies relevant files to a writeable path on the base layer (currently `C:\Users\Public\Documents`)

Once the install is complete, you can use `flare-wsb.bat` to launch your new WSB image. This will prompt you to provide some options and will automatically initiate post-install activities (mainly moving files). 

To see **FLARE-WSB** in action and for more technical details, check out my blog post (TBD).

### Requirements

* [Windows Sandbox](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-install)**
    * Arm64 (for Windows 11, version 22H2 and later) or AMD64 architecture
    * Virtualization capabilities enabled in BIOS
    * At least 4 GB of RAM (8 GB recommended)
    * At least 1 GB of free disk space (SSD recommended)
    * At least two CPU cores (four cores with hyper-threading recommended)
* [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.5)
    * The `install.ps1` script will prompt you to install with WinGet

Last confirmed working OS: `Windows 11 Pro 26200.7462 (25H2)`

> [!NOTE]
> *The install script will use `bin/config.xml` (modified to comment out packages with known issues) and `bin/LayoutModification.xml` (unmodified). If you want to edit these files, please read: [FLARE-VM Configuration](https://github.com/mandiant/flare-vm?tab=readme-ov-file#configuration).

> [!NOTE]
> **After installing Windows Sandbox for the first time, you will need to run it on its own first to generate the base layer image.

### Disclaimers

* I have tried my best to make as many of the FLARE VM tools work in WSB as possible, but you may encounter incompatibilities. If you identify any, please create an issue on this repo.
* Files related to the FLARE VM tools will ultimately be stored on your host machine. This may trigger anti-virus alerts depending on the tool, and it is suggested that you add an AV exclusion to `C:\ProgramData\Microsoft\Windows\Containers\Layers` or the base layer directory (the oldest modified folder).

### Credits and Acknowledgements
- Mandiant/Google and the maintainers of [FLARE-VM](https://github.com/mandiant/flare-vm).
- Alex Ilgayev at Check Point with their [Windows Sandbox research](https://research.checkpoint.com/2021/playing-in-the-windows-sandbox/) and the idea for this project.
- [gerneio](https://github.com/gerneio) and their [WindowsSandboxPlayground](https://github.com/gerneio/WindowsSandboxPlayground) project for the WDAGUtilityAccount password retrieval technique and their collection of Windows Sandbox research.
