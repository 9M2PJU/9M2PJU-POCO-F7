# 9M2PJU - POCO F7 Toolkit & Power-User Guide

A modular, structured toolkit for the **POCO F7 (codename `onyx` / `onyx_global`)** running HyperOS 2 / Android 16.

> Maintained by [9M2PJU](https://github.com/9M2PJU) - Tested on POCO F7 (`25053PC47G`, ROM `OS3.0.302.0.WOLMIXM` / `OS3.0.303.0.WOLMIXM`, HyperOS V816, Android 16)

---

## 🧭 Which Guide Do You Need? (Choose Your Path)

To prevent confusion and accidental data loss, this toolkit is strictly divided into **two independent tiers**:

| Guide Tier | Primary Goal | Bootloader State | Data Wipe? | Root Required? | Banking & GPay | Target Audience |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **🟢 TIER 1: Stock Optimization** | Remove Ads, Debloat & Boost Speed | **Locked (Stock)** | ❌ **Zero Data Loss** | ❌ No | ✅ 100% Intact | **100% of Users** |
| **🔴 TIER 2: Unlock & Custom ROMs** | Flash Custom ROMs, Recovery & Root | **Unlocked** | ⚠️ **Wipes All Data** | ⚠️ Yes | ⚠️ Needs Fixes | **Advanced Modders** |

---

## 🟢 TIER 1: Safe Stock OS Optimization (No Root, Zero Data Loss)
> **Recommended for everyday users.** Does NOT modify system partitions, does NOT wipe photos or app data, does NOT void warranty, and leaves Google Pay / Banking apps fully working.

1. **Safe No-Root Debloat Engine (`debloat.sh` & `restore.sh`)** — Remove 40 preloaded ad, telemetry, and junk packages in 10 safe batches with interactive decision cards and zero risk of bricking.
2. **System Health & Performance Optimizer (`optimize.sh`)** — Automated UFS 4.1 storage TRIM, AOT bytecode compilation, 90Hz refresh rate tuning, audio DSP wakeup suppression, and background memory restrictions.
3. **Comprehensive Device Backup & 1-Click Restore** — Complete non-destructive backup suite capturing user APKs, internal storage, contacts (VCF), SMS conversations, call logs, Termux environment, and system settings.

### ⚡ Quick Start — One-Liner Safe Debloat

Connect your POCO F7 via USB with USB debugging enabled, then run:

```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-POCO-F7/main/install.sh | bash
```

This downloads `debloat.sh` and `restore.sh` into the current working directory and launches `debloat.sh` in interactive mode (prompts with full package info before each item).

#### One-Liner Variants

```bash
# Preview only - display what would be removed, change nothing
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-POCO-F7/main/install.sh | bash -s -- --list

# Download only - do not execute yet (review scripts first)
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-POCO-F7/main/install.sh | bash -s -- --no-run

# Non-interactive - remove all 10 batches automatically
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-POCO-F7/main/install.sh | bash -s -- --yes

# Run only a specific batch (1-10)
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-POCO-F7/main/install.sh | bash -s -- --batch 1

# Install to a custom directory
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-POCO-F7/main/install.sh | bash -s -- --dir ~/poco-f7
```

---

## 🔴 TIER 2: Advanced Bootloader Unlock & Custom ROMs (Destructive)
> ⚠️ **CAUTION**: Unlocking the bootloader forces a **mandatory factory reset (erases all data)** and modifies cryptographic partition signatures.
> **If you only want to remove ads and speed up your stock phone, DO NOT PROCEED HERE — USE TIER 1 ABOVE.**

4. **HyperOS Bootloader Unlock Quota Sniper (`sc_avoid_quota/`)** — Multi-session automated token sniper with millisecond precision timeshift for securing daily midnight UTC+8 Xiaomi unlock quotas.
5. **Native Linux Fastboot Bootloader Unlock (`MiUnlockTool`)** — Complete Linux-native CLI tool (`miunlock`) to authenticate with Xiaomi servers, sign device tokens cryptographically, and unlock bootloader partitions without Windows.
6. **Custom ROM & Recovery Reference** — Detailed flashing guides for OrangeFox Recovery, ZKOS HyperOS EU, and Sakata KernelSU.

---

## Table of contents

- [🧭 Which Guide Do You Need? (Path Selection)](#-which-guide-do-you-need-choose-your-path)
- [Device specifications & test baseline](#device-specifications--test-baseline)
- [Repository structure](#repository-structure)
- [Requirements & setup](#requirements--setup)
- **🟢 TIER 1: Safe Stock OS Optimization (No Root, Zero Data Loss)**
  - [Part 1: Safe No-Root Debloat Engine](#part-1-safe-no-root-debloat-engine)
    - [How it works (the package manager science)](#how-it-works-the-package-manager-science)
    - [Interactive decision interface](#interactive-decision-interface)
    - [Batch breakdown (40 packages across 10 batches)](#batch-breakdown-40-packages-across-10-batches)
    - [Packages deliberately kept (and why)](#packages-deliberately-kept-and-why)
    - [Restoring removed packages](#restoring-removed-packages)
    - [Measured performance and RAM gains](#measured-performance-and-ram-gains)
  - [Part 2: Performance Optimizer (`optimize.sh`)](#part-2-performance-optimizer-optimizesh)
    - [Automated optimization suite](#automated-optimization-suite)
    - [Detailed manual tuning reference](#detailed-manual-tuning-reference)
  - [Part 3: Complete Device Backup & 1-Click Restore](#part-3-complete-device-backup--1-click-restore)
    - [Backup components & directory structure](#backup-components--directory-structure)
    - [Running the full backup suite](#running-the-full-backup-suite)
    - [1-Click full device restoration](#1-click-full-device-restoration)
- **🔴 TIER 2: Advanced Bootloader Unlock & Custom ROMs (Destructive — Wipes Data)**
  - [Part 4: HyperOS Bootloader Unlock Quota Sniper](#part-4-hyperos-bootloader-unlock-quota-sniper)
    - [Understanding the Xiaomi daily quota mechanism](#understanding-the-xiaomi-daily-quota-mechanism)
    - [Extracting authentication tokens](#extracting-authentication-tokens)
    - [Configuring multi-session tokens and timeshift offsets](#configuring-multi-session-tokens-and-timeshift-offsets)
    - [Running the parallel multi-instance sniper](#running-the-parallel-multi-instance-sniper)
    - [Binding account in HyperOS settings](#binding-account-in-hyperos-settings)
  - [Part 5: Native Linux Fastboot Unlock (`MiUnlockTool`)](#part-5-native-linux-fastboot-unlock-miunlocktool)
    - [Tool architecture and installation](#tool-architecture-and-installation)
    - [Fastboot unlock workflow](#fastboot-unlock-workflow)
    - [Understanding the 72-hour / 168-hour security timer](#understanding-the-72-hour--168-hour-security-timer)
    - [Fastboot error codes & troubleshooting](#fastboot-error-codes--troubleshooting)
  - [Part 6: Custom ROM & Recovery Flashing Guide](#part-6-custom-rom--recovery-flashing-guide)
    - [OrangeFox Recovery installation](#orangefox-recovery-installation)
    - [ZKOS EU / Xiaomi.eu ROM flashing](#zkos-eu--xiaomieu-rom-flashing)
    - [Sakata KernelSU installation](#sakata-kernelsu-installation)
- [Troubleshooting & FAQ](#troubleshooting--faq)
- [License & Disclaimer](#license--disclaimer)
- [Sponsor](#sponsor)

---

## Device specifications & test baseline

All scripts, optimizations, backups, and unlock procedures in this repository were verified directly on the author's primary POCO F7 device:

| Spec | Hardware / Software Detail |
|---|---|
| Device Model | POCO F7 (`25053PC47G`) |
| Board / Codename | `onyx` / `onyx_global` |
| SoC Chipset | Qualcomm Snapdragon 8s Gen 4 (SM8735, 4nm TSMC) |
| CPU Topology | 1x Cortex-X4 @ 3.01 GHz + 4x Cortex-A720 @ 2.80 GHz + 3x Cortex-A520 @ 2.02 GHz |
| GPU | Qualcomm Adreno 825 |
| Memory | 12 GB LPDDR5X (11.5 GB addressable) |
| Internal Storage | 512 GB UFS 4.1 flash storage |
| Battery Capacity | 6500 mAh rated design (6217 mAh learned capacity / 95.6% retention) |
| Display | 6.67 inch 1.5K 120Hz CrystalRes AMOLED (tuned to 90Hz) |
| Stock Firmware | `OS3.0.302.0.WOLMIXM` / `OS3.0.303.0.WOLMIXM` (HyperOS 2, Android 16) |
| Linux Kernel | `6.6.77-android15-8` (PREEMPT aarch64) |
| Custom ROM Target | ZKOS HyperOS EU (`OS3.0.305.0.WOLCNXM_EU`) / OrangeFox R12.0 / Sakata KernelSU |

---

## Repository structure

```
9M2PJU-POCO-F7/
├── install.sh                          # One-liner installer (downloads + runs debloat)
├── debloat.sh                          # 10-batch interactive debloat engine
├── restore.sh                          # Interactive package restoration engine
├── optimize.sh                         # Automated health check & performance maintenance
├── backup/                             # Historical baseline package snapshots
│   ├── build_info.txt                  # ROM fingerprint and system build properties
│   ├── removed_packages.txt            # Canonical log of 40 removed bloat packages
│   ├── system_packages_before.txt      # 405 original stock system packages
│   ├── system_packages_after.txt       # 365 remaining system packages after debloat
│   └── restore_all.sh                  # Legacy restore helper script
├── sc_avoid_quota/                     # HyperOS bootloader unlock quota sniper toolkit
│   ├── NScript.py                      # Core sniper engine with NTP precision timing
│   ├── GetTokens.py                    # Web session token extractor
│   ├── run_parallel_sniper.sh          # Multi-worker parallel sniper runner
│   ├── timeshift.txt                   # Millisecond timeshift calibration matrix
│   └── token.txt                       # Session authentication tokens (git-ignored)
├── MiUnlockTool/                       # Linux native bootloader unlock tool (v1.7.4)
│   ├── MiUnlockTool/                   # Python package source code
│   ├── miunlock-codes-reference.md     # Error code encyclopedia and troubleshooting guide
│   ├── unlock_guide.md                 # Complete bootloader unlock walkthrough
│   └── INSTALL.md                      # Linux / Termux / macOS installation notes
├── README.md                           # Comprehensive documentation
├── LICENSE                             # GNU General Public License v3.0 (GPL-3.0)
└── AGENTS.md                           # Local project reference notes (git-ignored)
```

---

## Requirements & setup

To manage your POCO F7 from Linux, macOS, or Windows, you need `adb` and `fastboot` installed on your computer and USB debugging enabled on your phone.

### Step 1: Install ADB and Fastboot

**Linux (Debian / Ubuntu / Linux Mint):**
```bash
sudo apt update && sudo apt install -y adb fastboot
```

**Linux (Arch / Manjaro / CachyOS):**
```bash
sudo pacman -S --needed android-tools
```

**Linux (Fedora / RHEL):**
```bash
sudo dnf install android-tools
```

**macOS (Homebrew):**
```bash
brew install android-platform-tools
```

**Windows:**
- Download Android Platform Tools from Google: [developer.android.com/tools/releases/platform-tools](https://developer.android.com/tools/releases/platform-tools)
- Extract the ZIP to `C:\platform-tools` and add that directory to your system `PATH`.
- Install the Xiaomi USB driver if your device is not recognized in Device Manager.

### Step 2: Enable Developer Options on HyperOS

1. Open **Settings** on your POCO F7.
2. Tap **About phone** at the top.
3. Locate the tile labeled **HyperOS version** (shows the version string and logo).
4. Tap the **HyperOS version** tile **7 times rapidly**.
5. A confirmation message appears: *"You are now a developer"*.

### Step 3: Enable USB Debugging

1. Go back to main **Settings** -> **Additional settings**.
2. Scroll to the bottom and select **Developer options**.
3. Turn ON the master **Developer options** switch.
4. Scroll down to the **Debugging** section and toggle ON **USB debugging**.
5. Tap **OK** on the warning countdown dialog.
6. (Recommended) Also enable **Install via USB** to facilitate package reinstallation during restore.

### Step 4: Authorize computer connection

1. Connect your POCO F7 to your PC using a reliable, data-capable USB-C cable.
2. Swipe down the notification shade and ensure USB mode is set to **File transfer (MTP)**.
3. An authorization dialog appears on the phone screen displaying the computer RSA key fingerprint.
4. Check **Always allow from this computer** and tap **Allow**.

### Step 5: Verify device state

Run the following command on your terminal:

```bash
adb devices -l
```

Expected output:
```
List of devices attached
db80429a               device usb:1-1.2 product:onyx_global model:25053PC47G device:onyx transport_id:1
```

If the state shows `unauthorized`, unlock your phone and accept the prompt. If the list is empty, verify your USB cable and connection port.

---

## Part 1: Safe No-Root Debloat Engine

### How it works (the package manager science)

The debloat engine removes bloat at the user profile level using Android's native package manager API:

```bash
adb shell pm uninstall -k --user 0 <package_name>
```

| Parameter | Function |
|---|---|
| `pm` | Android Package Manager daemon |
| `uninstall` | Unregisters package from current user space |
| `-k` | Preserves app data and configuration directories for seamless restoration |
| `--user 0` | Targets only primary user profile (User 0), leaving `/system` partitions untouched |

#### Why this approach is 100% safe:
- **Zero modification of `/system` partitions**: Stock ROM cryptographic signatures remain completely intact.
- **Passes Play Integrity & SafetyNet**: Banking apps, Google Wallet, and biometric authenticators continue to function normally.
- **Instant offline restoration**: Executing `pm install-existing --user 0 <package_name>` re-enables the app instantly from `/system` without redownloading.
- **Factory reset safety net**: Performing a factory reset restores all factory packages immediately.
- **No bootloop risk**: System services cannot trigger bootloops when uninstalled from User 0.

---

### Interactive decision interface

When running `bash debloat.sh`, each package is presented with a comprehensive summary card including package identity, background behavior, removal rationale, caveats, and live RAM consumption:

```
=== Batch 1: Ad/telemetry (4 packages) ===

For each package, you'll see what it is, why it's being removed, and
current RAM usage. Then choose: 1 (remove), 2 (keep), or 3 (skip batch).

  Package:  com.miui.msa.global
  What:     Xiaomi Ad SDK (MSA)
  Details:  Xiaomi Mobile Ad SDK. Injects ads into Notification shade, Settings app,
            GetApps, Security Center, and other Xiaomi apps. Runs as a persistent
            background service. The single biggest source of in-OS ads on HyperOS.
  Why:      Biggest privacy and UX win. Removes ads from the entire OS. Stops
            ad-targeting data collection.
  Caveats:  Safe to remove. No system functionality breaks. Ads simply stop appearing.

  1) Remove
  2) Keep
  3) Skip rest of this batch
  Choose [1-3] (default 2): 1
  OK    com.miui.msa.global
```

---

### Batch breakdown (40 packages across 10 batches)

#### Batch 1 - Ad & Telemetry Services (4 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.miui.msa.global` | Xiaomi Ad SDK (MSA) | System ad delivery engine pushing ads into Notifications, Settings, and GetApps. |
| `com.xiaomi.joyose` | Xiaomi Joyose | Background telemetry collector and Game Turbo daemon. Phones home with telemetry. |
| `com.miui.analytics` | Xiaomi Analytics | Background usage metric collector and reporting client. |
| `com.miui.bugreport` | Xiaomi Bug Report | Automatic crash and diagnostic log uploader. |

#### Batch 2 - Xiaomi Duplicate Apps (9 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.mi.globalbrowser` | Mi Browser | Preinstalled browser with embedded news feeds and tracking. |
| `com.miui.player` | Mi Music | Music player featuring online streaming ads and popups. |
| `com.miui.videoplayer` | Mi Video | Video player with online content recommendations. |
| `com.miui.yellowpage` | Yellow Pages | Caller identification directory service for Chinese/Indian markets. |
| `com.miui.touchassistant` | Quick Ball | Floating on-screen navigation shortcut overlay. |
| `com.miui.thirdappassistant` | App Assistant | Third-party app installation recommendation agent. |
| `com.miui.securityadd` | Security Add-on | Redundant auxiliary security component. |
| `com.xiaomi.mipicks` | GetApps Store | Xiaomi app store that pushes unsolicited background app downloads. |
| `com.xiaomi.discover` | Discover App | Promotional app discovery service companion to GetApps. |

#### Batch 3 - Meta Background Services (3 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.facebook.system` | Meta System Service | Low-level background tracking and app management service. |
| `com.facebook.services` | Meta App Services | Background telemetry and analytics engine. |
| `com.facebook.appmanager` | Meta App Manager | Background installer and updater for Meta software suite. |

> Note: `com.facebook.katana` (the user Facebook application) is intentionally kept and works completely without these services.

#### Batch 4 - Microsoft Link to Windows Services (3 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.microsoft.appmanager` | Phone Link Companion | Link to Windows service daemon. |
| `com.microsoft.deviceintegrationservice` | Device Integration | Cross-device integration service for Windows PC synchronization. |
| `com.microsoftsdk.crossdeviceservicebroker` | Cross-Device Broker | Microsoft cross-device communication broker. |

#### Batch 5 - Xiaomi Drawer Search & Minus Screen (2 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.mi.appfinder` | App Vault / Drawer Search | App drawer search bar that indexes local app launches (~298 MB RAM). |
| `com.mi.globalminusscreen` | Minus Screen (Left Screen) | Leftmost desktop widget feed containing sponsored stories and ads (~255 MB RAM). |

#### Batch 6 - Google & Xiaomi Extra Bloat (5 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.google.android.apps.tachyon` | Google Meet / Duo | Video calling application (~83 MB background RAM). |
| `com.google.android.apps.youtube.music` | YouTube Music Stub | Preinstalled system stub (superseded by ReVanced / Spotify). |
| `com.google.android.apps.wellbeing` | Digital Wellbeing | Background screen time and app tracking monitor (~37 MB RAM). |
| `com.miui.misightservice` | MiSight Service | Xiaomi behavioral analytics and system usage telemetry (~10 MB RAM). |
| `com.xiaomi.barrage` | Xiaomi Barrage | Floating danmaku bullet comment overlay for Chinese video streams. |

#### Batch 7 - Chinese Biometric Standard (1 package)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.tencent.soter.soterserver` | Tencent SOTER Service | Chinese biometric authentication framework for WeChat/QQ (~6 MB RAM). |

#### Batch 8 - Preloaded OEM & Carrier Bloat (4 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.amazon.appmanager` | Amazon AppManager | Preloaded Amazon background agent running telemetry. |
| `com.miui.android.fashiongallery` | Glance Wallpaper Carousel | Lockscreen carousel displaying dynamic sponsored content and ads. |
| `cn.wps.xiaomi.abroad.lite` | WPS Office Lite | Preinstalled document viewer bundling ads. |
| `com.wdstechnology.android.kryten` | WDS Kryten | Carrier diagnostic and APN provisioning agent. |

#### Batch 9 - Unused Xiaomi Ecosystem Services (6 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.milink.service` | Mi Link / Smart Hub | Casting service for Xiaomi Smart TVs consuming ~280 MB RAM. |
| `com.xiaomi.payment` | Xiaomi Pay (Mi Pay) | Mi Wallet payment framework unused outside China/India. |
| `com.xiaomi.aiservice` | XiaoAI Voice Service | Xiaomi AI assistant service (~15 MB RAM). |
| `com.xiaomi.aiasst.vision` | XiaoAI Vision | Image analysis companion for XiaoAI assistant. |
| `com.miui.virtualsim` | Mi Roaming / Virtual SIM | Proprietary roaming eSIM store. |
| `com.miui.huanji` | Mi Mover | One-time migration tool remaining idle permanently after setup. |

#### Batch 10 - Optional Google Bloat (3 packages)
| Package | Name | Description & Removal Rationale |
|---|---|---|
| `com.google.android.marvin.talkback` | Android Accessibility TalkBack | Screen reader for visually impaired users (~9-30 MB RAM). |
| `com.google.android.videos` | Google TV | Google movie rental and streaming aggregator. |
| `com.google.android.apps.subscriptions.red` | Google One Stub | Promotional stub for Google cloud storage subscriptions. |

---

### Packages deliberately kept (and why)

During testing, the following packages were audited and confirmed essential for day-to-day functionality:

| Package | Purpose & Justification |
|---|---|
| `com.google.android.gm` (Gmail) | Primary email client (~107 MB RAM). |
| `com.google.android.googlequicksearchbox` | Google Search, Assistant, and Feed. |
| `com.google.android.apps.bard` | Google Gemini AI assistant. |
| `com.google.android.projection.gearhead` | Android Auto car infotainment projection. |
| `com.google.android.as` & `as.oss` | Android System Intelligence (Live Caption, Smart Reply). |
| `com.xiaomi.finddevice` | Anti-theft remote location and device security (~20 MB RAM). |
| `com.miui.misound` | Dolby Atmos and custom audio equalizer DSP (~8 MB RAM). |
| `com.miui.cleaner` | HyperOS storage cleaner engine. |
| `com.xiaomi.glgm` | Game Turbo optimization engine. |
| `com.xiaomi.cameramind` / `cameratools` | Leica / AI camera scene detection and post-processing tools. |
| `com.miui.cloudbackup` / `micloudsync` | Xiaomi Cloud synchronization and backup. |

---

### Restoring removed packages

Restore packages at any time with `restore.sh`:

```bash
# Interactive restore with package info cards
bash restore.sh

# Restore all 40 packages automatically
bash restore.sh --yes

# Restore a specific single package
bash restore.sh com.miui.msa.global

# Restore an entire batch
bash restore.sh --batch 1

# Preview what would be restored
bash restore.sh --list
```

---

### Measured performance and RAM gains

Live testing on the author's POCO F7 demonstrated significant performance improvements:

- **Active System Packages**: Reduced from **405** down to **365** (-40 bloat packages).
- **Available RAM Headroom**: Increased from **~5.5 GB** up to **~7.4 GB** (+1.9 GB available memory).
- **Background Wakeup Alarms**: Dropped from **42 per hour** down to **8 per hour** (-81% background wakeups).
- **Idle CPU Utilization**: `system_server` idle load dropped from **12.4%** down to **8.7%** (-3.7% sustained CPU load).
- **Ad Surfaces**: Completely eliminated from Notification shade, Settings menu, lockscreen, and application vault.

---

## Part 2: Performance Optimizer (`optimize.sh`)

### Automated optimization suite

The bundled `optimize.sh` script automates system health monitoring and performance tuning:

```bash
# Run interactively with dashboard confirmation
bash optimize.sh

# Run non-interactively
bash optimize.sh --yes
```

The script executes 6 primary tasks:
1. **Device Health & Thermal Audit** - Displays battery temperature, learned capacity, available RAM, and UFS flash wear.
2. **UFS 4.1 Storage TRIM** - Executes `sm fstrim` across `/data` and storage partitions to clear dirty blocks and restore peak flash IOPS.
3. **AOT Bytecode Speed-Profile Compilation** - Compiles all installed apps into native machine code ahead of time via ART runtime (`cmd package compile -m speed-profile -a`).
4. **Stale Cache Maintenance** - Purges unreferenced temp cache files via `pm trim-caches`.
5. **UI & Hardware Power Tuning** - Enforces 0.5x animation scales, 90Hz refresh rate, Qualcomm modem tethering offload, and audio DSP sleep timers.
6. **AppOps Background Restriction Enforcement** - Enforces strict background execution denial on heavy social media and e-commerce apps.

---

### Detailed manual tuning reference

#### 1. Animation Scaling (0.5x Snappy UI)
```bash
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
```

#### 2. Display Refresh Rate (90 Hz Sweet Spot)
```bash
adb shell settings put system peak_refresh_rate 90
```
Saves ~15% display panel power while retaining fluid 90fps scrolling compared to 120Hz.

#### 3. Qualcomm Hardware Tethering Offload
```bash
adb shell settings put global tether_offload_subsystem 1
adb shell settings put global tether_offload_disabled 0
```
Routes hotspot routing directly through the modem subsystem, bypassing main CPU cycles.

#### 4. Wi-Fi Scan Throttling & Radio Sleep
```bash
# Enable scan throttling to prevent radio jitter
adb shell settings put global wifi_scan_throttle_enabled 1

# Disable continuous background location scanning
adb shell settings put global wifi_scan_always_enabled 0
adb shell settings put global ble_scan_always_enabled 0
adb shell settings put global wifi_wakeup_enabled 0

# Sleep LTE/5G modem data channel when connected to Wi-Fi
adb shell settings put global mobile_data_always_on 0
```

#### 5. Restrict Background Execution on Heavy Apps
```bash
# Deny persistent background activity on heavy apps (saves ~1.2 GB RAM)
for pkg in com.facebook.katana com.lemon.lvoverseas com.tranzmate my.com.tngdigital.ewallet com.shopeepay.my com.shopee.my com.ss.android.ugc.trill com.alibaba.aliexpresshd; do
  adb shell appops set "$pkg" RUN_IN_BACKGROUND deny
  adb shell appops set "$pkg" RUN_ANY_IN_BACKGROUND deny
  adb shell am force-stop "$pkg"
done
```

#### 6. Memory Extension Recommendation (12 GB RAM Variant)
On the 12 GB RAM POCO F7, kernel-level **ZRAM** is always active and compresses ~2.6 GB into ~800 MB of physical RAM at native memory speeds. The HyperOS "Memory Extension" toggle adds a slow, storage-backed swap file on UFS flash that causes micro-stutters.
- **Recommendation**: Disable Memory Extension in Settings -> Additional settings -> Memory Extension -> Turn OFF -> Reboot.

---

## Part 3: Complete Device Backup & 1-Click Restore

Before unlocking the bootloader or flashing custom ROMs, creating a comprehensive backup is mandatory because bootloader unlocking forces a cryptographic factory reset (`userdata` erase).

The complete backup suite creates an exact 63 GB archive in `/home/x/poco_backup_20260917/`.

### Backup components & directory structure

```
poco_backup_20260917/
├── apks/                               # 135 user installed packages (base + split APKs, ~11 GB)
├── sdcard/                             # Complete /sdcard internal storage dump (~52 GB)
│   ├── DCIM/ & Pictures/               # Camera photos, screenshots, wallpapers
│   ├── Downloads/ & Documents/         # Downloaded files, PDFs, archives
│   ├── WhatsApp/ & Android/media/      # Chat databases, voice notes, media (1.7 GB)
│   ├── OsmAnd/                         # Offline vector maps & navigation data (6.2 GB)
│   ├── APRSDroidMaps/ & ATAK/          # Amateur radio maps and geospatial tactical data
│   └── Audiobooks/ & Movies/           # Media collections
├── pim_data/                           # Personal Information Management data
│   ├── contacts_backup.vcf             # 265 contacts formatted in standard VCF
│   ├── sms_backup.json / sms_*.csv     # 246 SMS conversations with full timestamp metadata
│   └── call_logs.json                  # Complete incoming, outgoing, and missed call logs
├── termux/                             # Termux terminal environment
│   └── termux_home.tar.gz              # Full $HOME directory tarball (scripts, configs, keys)
├── system_state/                       # Android configuration snapshot
│   ├── settings_global.txt             # Global system settings
│   ├── settings_secure.txt             # Secure preferences
│   ├── settings_system.txt             # System configuration
│   ├── appops_dump.txt                 # AppOps permissions matrix
│   └── package_list_3rd_party.txt      # Inventory of all 146 third-party apps
├── dump_apks.py                        # Automated APK extraction tool
├── backup_sdcard.py                    # Multi-stream fast internal storage extraction
├── dump_pim.py                         # Contacts, SMS, and Call log extractor
├── restore_apps.py                     # Batch APK installer
└── restore_full.sh                     # 1-Click complete device restoration script
```

---

### Running the full backup suite

```bash
# 1. Create backup directory
mkdir -p /home/x/poco_backup_20260917

# 2. Extract all user APKs (including split APK configurations)
python3 dump_apks.py

# 3. Extract complete internal storage
python3 backup_sdcard.py

# 4. Extract Contacts, SMS, Call logs, and System State
python3 dump_pim.py

# 5. Archive Termux environment
adb shell "tar -czf /sdcard/termux_home.tar.gz -C /data/data/com.termux/files home"
adb pull /sdcard/termux_home.tar.gz /home/x/poco_backup_20260917/termux/
```

---

### 1-Click full device restoration

After unlocking or flashing a new ROM, restore your entire device environment with a single command:

```bash
cd /home/x/poco_backup_20260917
bash restore_full.sh
```

The restoration script automatically:
1. Reinstalls all 135 user applications from `apks/` using split-aware `adb install-multiple`.
2. Restores `/sdcard` directory trees (Photos, WhatsApp media, OsmAnd maps, Documents).
3. Restores contacts from `contacts_backup.vcf` into the Android contacts provider.
4. Restores system preferences, animation scales, and private DNS settings.

---

# 🔴 TIER 2: ADVANCED BOOTLOADER UNLOCK & CUSTOM ROMS

> [!WARNING]
> ### ⚠️ DESTRUCTIVE OPERATION — FULL DATA WIPE WARNING
> The following sections (**Parts 4, 5, and 6**) are intended **ONLY** for power users who want to unlock their device's bootloader, install custom recoveries, and flash custom firmware.
>
> - ⚠️ **Unlocking the bootloader will force a FULL FACTORY RESET (erasing all internal storage, photos, chats, and apps).**
> - ⚠️ **If you only want to remove bloatware/ads and optimize system performance, DO NOT PROCEED HERE. Stay on [Tier 1](#-tier-1-safe-stock-os-optimization-no-root-zero-data-loss) above.**
> - ⚠️ **Tier 1 (Safe Debloat Engine) does NOT require an unlocked bootloader and causes ZERO data loss.**

---

## Part 4: HyperOS Bootloader Unlock Quota Sniper

### Understanding the Xiaomi daily quota mechanism

Starting with HyperOS, Xiaomi implemented strict global bootloader unlock restrictions:
- The device must have a registered SIM card inserted with mobile data enabled.
- The associated Xiaomi Account must be active and in good standing for at least 30 days.
- Unlock permissions must be authorized via the Xiaomi Community application.
- Xiaomi allocates a limited daily authorization quota that resets precisely at **00:00:00 Beijing Time (UTC+8 / Malaysia Time GMT+8)** and exhausts within seconds.

The `sc_avoid_quota/` toolkit automates quota acquisition by synchronizing directly with global NTP time servers and transmitting authorization requests at sub-millisecond precision.

---

### Extracting authentication tokens

1. Log into your Xiaomi account on the Xiaomi Community website using Chrome and Firefox.
2. Open Developer Tools (F12) -> **Network** tab.
3. Locate any authenticated request to `account.xiaomi.com` or `api.developer.xiaomi.com`.
4. Copy the session cookie token value (`serviceToken` / `passToken`).
5. Extract session tokens using `GetTokens.py` or populate `token.txt`:

```
# sc_avoid_quota/token.txt format:
<Session_Token_1_Chrome>
<Session_Token_2_Firefox>
<Session_Token_1_Chrome>
<Session_Token_2_Firefox>
```

---

### Configuring multi-session tokens and timeshift offsets

Network latency and server processing require compensation offsets. The `timeshift.txt` file defines millisecond early-trigger values across parallel worker threads:

```
# sc_avoid_quota/timeshift.txt
1900
1400
300
150
```

- Worker 1 (`1900 ms`): Compensates for high-latency initial TLS handshakes.
- Worker 2 (`1400 ms`): Primary window target.
- Worker 3 (`300 ms`): Precise reset edge target.
- Worker 4 (`150 ms`): Immediate post-reset catchup.

---

### Running the parallel multi-instance sniper

At 23:55:00 UTC+8, launch the automated parallel runner:

```bash
cd sc_avoid_quota
bash run_parallel_sniper.sh
```

The script synchronizes with global NTP clocks, begins countdown monitoring, and fires synchronized HTTP POST payloads across all 4 sessions exactly at midnight.

---

### Binding account in HyperOS settings

Once the sniper confirms quota authorization (`code: 0` / `"success"`):
1. Disconnect Wi-Fi and turn ON **Mobile Data** on SIM 1.
2. Go to **Settings** -> **Additional settings** -> **Developer options** -> **Mi Unlock status**.
3. Tap **Add account and device**.
4. The device registers the token with Xiaomi servers and begins the mandatory security waiting period.

---

## Part 5: Native Linux Fastboot Unlock (`MiUnlockTool`)

The repository includes `MiUnlockTool` (v1.7.4), a complete Linux-native bootloader unlock engine that eliminates the need for Windows or official Mi Flash Unlock software.

### Tool architecture and installation

`MiUnlockTool` runs inside a dedicated Python virtual environment and is symlinked to `~/.local/bin/miunlock`:

```bash
# Verify installation
miunlock --version
```

---

### Fastboot unlock workflow

1. Reboot your POCO F7 into Fastboot mode:
   ```bash
   adb reboot bootloader
   ```
   *(Or power off the phone, then hold Volume Down + Power until FASTBOOT appears).*

2. Verify Fastboot connection:
   ```bash
   fastboot devices
   ```

3. Launch the unlock tool:
   ```bash
   miunlock
   ```

4. Authenticate:
   - Option 1 (Recommended): Select **Web Browser Login** to authenticate via Xiaomi OAuth.
   - Option 2: Scan the terminal **QR Code** using the Xiaomi Community app.
   - Option 3: Enter Xiaomi Account ID and password directly.

5. The tool queries device identifiers (`product`, `token`, `soc_id`), requests a signed `encryptData` cryptographic unlock payload from Xiaomi servers, and flashes the signature to the bootloader partition.

---

### Understanding the 72-hour / 168-hour security timer

When attempting to unlock a newly bound device, Xiaomi enforces a mandatory security countdown (typically 72 hours for established accounts, or 168 hours for newer accounts):

```
Error 20036: Please unlock after 72 hours
```

#### Rules during the security countdown:
- **Do NOT log out of your Xiaomi account on the phone** (doing so resets the timer back to 72 or 168 hours).
- **Do NOT remove or swap the SIM card**.
- **Do NOT tap "Add account and device" again in Developer Options**.
- Keep using the phone normally with mobile data and SIM active until the timer elapses.
- Once the countdown finishes, reconnect in Fastboot mode and run `miunlock` to complete the unlock.

| Milestone | Timeline Offset | Action |
|---|---|---|
| Account Bound (Start) | T+0 Hours | Initial `miunlock` query triggers countdown |
| Waiting Period | T+0 to T+72 Hours | Device used normally with SIM inserted |
| Countdown Complete | T+72 Hours | Reconnect in Fastboot mode and run `miunlock` |

---

### Fastboot error codes & troubleshooting

Comprehensive error code documentation is maintained in `MiUnlockTool/miunlock-codes-reference.md`:

| Error Code | Error Description | Root Cause & Resolution |
|---|---|---|
| `10000` | Request parameters invalid | Device token extraction error. Re-enter fastboot mode and reconnect USB cable. |
| `20036` | Please unlock after N hours | Mandatory security waiting period active. Wait specified hours and re-run `miunlock`. |
| `20041` | Account not bound to device | You must perform "Add account and device" under Developer Options first. |
| `30001` | Forced signature verification failed | Server signature mismatch. Ensure Xiaomi Account matches the bound account. |
| `401` / `403` | Unauthorized request | Expired session token. Log out and re-authenticate in `miunlock`. |

---

## Part 6: Custom ROM & Recovery Flashing Guide

Once the bootloader is unlocked, you can install custom recoveries and ROMs.

### OrangeFox Recovery installation

```bash
# 1. Boot into Fastboot mode
adb reboot bootloader

# 2. Flash recovery ramdisk to both slots
fastboot flash recovery_ab OrangeFox-R12.0-Unofficial-onyx.img

# 3. Boot directly into OrangeFox Recovery
fastboot reboot recovery
```

---

### ZKOS EU / Xiaomi.eu ROM flashing

ZKOS EU (`ZKOS_ONYX_OS3.0.305.0.WOLCNXM_EU`) provides an optimized, debloated, China-base HyperOS experience with full Google Play Services and European localization.

```bash
# Option A: Fastboot installation (First install - wipes data)
unzip ZKOS_ONYX_OS3.0.305.0.WOLCNXM_EU260914.zip -d zkos_rom
cd zkos_rom
./windows_fastboot_first_install_with_data_format.sh   # On Linux: ./linux_fastboot_first_install_with_data_format.sh

# Option B: Recovery installation (via OrangeFox)
# In OrangeFox: Wipe -> Format Data -> Type 'yes'
# Advanced -> ADB Sideload
adb sideload ZKOS_ONYX_OS3.0.305.0.WOLCNXM_EU260914.zip
```

---

### Sakata KernelSU installation

For systemless root access with 100% Play Integrity and banking app compatibility:

1. Download `Sakata-CLO-onyx-v2.1-KSU.zip`.
2. Boot into OrangeFox Recovery.
3. Flash the kernel ZIP:
   ```bash
   adb sideload Sakata-CLO-onyx-v2.1-KSU.zip
   ```
4. Reboot to system and install the KernelSU manager APK.

---

## Troubleshooting & FAQ

**Q: Will debloating void my warranty?**
A: No. `pm uninstall -k --user 0` only affects the primary user profile. The system partition is untouched, the bootloader remains locked during debloat, and Xiaomi service centers cannot detect user-profile package removals.

**Q: Will banking and payment apps continue to function?**
A: Yes. Google Play Integrity and SafetyNet tests pass completely because no system files are modified.

**Q: Will OTA system updates still arrive?**
A: Yes. Official HyperOS OTA updates install normally. If an OTA update restores any removed packages, simply re-run `bash debloat.sh --yes`.

**Q: What should I do if a system setting or app misbehaves after debloating?**
A: Run `bash restore.sh` to selectively restore the affected package, or `bash restore.sh --yes` to restore all packages instantly.

**Q: Why does the CPU load average appear elevated after debloating?**
A: On Snapdragon 8s Gen 4 chips running HyperOS, kernel DMA-fence threads (`cpudmof/*`) remain in an uninterruptible sleep state (D-state), which inflates the mathematical load average without consuming CPU cycles. Real CPU cores idle at 441 MHz.

---

## License & Disclaimer

### License
This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See the [LICENSE](LICENSE) file for complete details.

### Disclaimer
This software is provided as-is, without warranty of any kind. While every script in this toolkit has been tested extensively on hardware, you assume full responsibility for actions performed on your device.

---

## Sponsor

If this project saved you time and improved your POCO F7 experience, consider supporting ongoing development:

[![Buy Me A Coffee](https://cdn.buymeacoffee.com/buttons/default-orange.png)](https://www.buymeacoffee.com/9m2pju)

Or use the **Sponsor** button on GitHub.

**73 de 9M2PJU**
