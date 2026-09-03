# LazyDotBat

A collection of Windows batch scripts for system maintenance, optimization, and information gathering. Run them instead of digging through Windows settings.

> All scripts require **Run as Administrator**.

## Quick Start (Master Launcher)

Run `LazyDotBat.bat` from the root of the repository (or `bat/menu.bat`):

```cmd
LazyDotBat.bat
```

The interactive menu lets you run any tool, view system diagnostics, or run the complete audit suite from a single, color-coded console.

## Structure

```
LazyDotBat/
├── LazyDotBat.bat  Master interactive launcher
└── bat/
    ├── menu.bat    Subfolder launcher shortcut
    ├── tools/      Action scripts (clean, optimize, fix)
    ├── info/       Read-only system information scripts
    └── ps1/        PowerShell scripts used by info/
```

## Scripts

### `tools/`
| Script | What it does |
|---|---|
| `disk_cleaner.bat` | Remove junk files, cache, and temp folders |
| `ram_flush.bat` | Purge standby memory list to actually free RAM |
| `network_boost.bat` | Flush DNS, reset network stack, switch DNS provider or revert to DHCP |
| `boost_for_gaming.bat` | Optimize PC for gaming (with restore option) |
| `disable_windows_junk.bat` | Disable Windows bloatware and telemetry (with restore option) |
| `gpu_reset.bat` | Restart GPU driver to fix display issues |
| `restart_audio.bat` | Restart audio service to fix sound issues |
| `printer_fix.bat` | Restart print spooler and clear stuck print jobs |
| `peripheral_reset.bat` | Restart keyboard, mouse, and Bluetooth drivers to fix input issues |

### `info/`
| Script | What it does |
|---|---|
| `system_info.bat` | Full system overview: OS, CPU, RAM, GPU, storage, BIOS, HWID |
| `disk_health.bat` | Disk health, drive usage, volume status |
| `network_info.bat` | Active adapters, public IP, ping test |
| `open_ports.bat` | TCP/UDP listening ports with owning processes, flags suspicious ports |
| `security_audit.bat` | Firewall, antivirus, UAC, RDP, SMBv1, BitLocker, and more |

## Usage

1. Download or clone the repo
2. Right-click `LazyDotBat.bat` and select **Run as administrator** (or double-click to prompt for elevation)
3. Or right-click any individual `.bat` file in `bat/tools/` or `bat/info/` and select **Run as administrator**

## Requirements

- Windows 10 / 11
- Administrator privileges
- PowerShell 5.1+ (included with Windows)
