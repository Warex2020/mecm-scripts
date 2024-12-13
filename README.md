# MECM Scripts

This repository contains a collection of PowerShell scripts designed to enhance and simplify the management of Windows servers and devices in environments using Microsoft Endpoint Configuration Manager (MECM).

## Overview
These scripts serve various purposes, including system maintenance, user session tracking, update management, and security enhancement. Each script is designed to be modular, easy to use, and compatible with MECM deployments.

## Scripts

### 1. **Check Pending Updates**
- **Filename:** `Check_Pending_Updates.ps1`
- **Description:** Checks for any pending updates available through the Software Center.
- **Usage:** Displays a list of pending updates with details like titles and KB numbers.

### 2. **Download and Install Updates**
- **Filename:** `Download_Available_Updates.ps1`
- **Description:** Downloads all available updates from the Software Center without triggering a restart.

### 3. **Download Updates with Reboot**
- **Filename:** `Download_And_Reboot_Updates.ps1`
- **Description:** Downloads updates and initiates either a soft or hard reboot after completion.

### 4. **Check TPM Chip**
- **Filename:** `Check_TPM_Chip.ps1`
- **Description:** Checks if a TPM security chip is present on the system.

### 5. **Enable BitLocker**
- **Filename:** `Enable_BitLocker_With_TPM.ps1`
- **Description:** Enables BitLocker encryption on local drives using TPM without requiring a PIN during boot.

### 6. **Cancel Scheduled Reboot**
- **Filename:** `Cancel_Scheduled_Reboot.ps1`
- **Description:** Cancels any scheduled reboots initiated by the Software Center.

### 7. **Schedule Random Reboot**
- **Filename:** `Schedule_Random_Reboot.ps1`
- **Description:** Schedules a random reboot between 00:00 and 04:00.

### 8. **Track User Activity**
- **Filename:** `Track_User_Activity_Last7Days.ps1`
- **Description:** Tracks who was/has been logged in, calculates the duration of active (unlocked) sessions, and outputs total activity time for the last 7 days.

### 9. **Log Off All Users**
- **Filename:** `Logoff_All_Users.ps1`
- **Description:** Logs off all currently logged-in users from the system.

### 10. **System Cleanup**
- **Filename:** `System_Cleanup.ps1`
- **Description:** Cleans temporary files, update cache, and old log files, and empties the recycle bin.

### 11. **Check Software Center Restart Pending**
- **Filename:** `Check_Software_Center_Restart.ps1`
- **Description:** Checks if a restart is pending in the Software Center.

## Requirements
- **PowerShell:** Version 5.1 or later.
- **Administrator Privileges:** Many scripts require elevated permissions to execute successfully.
- **MECM Environment:** Some scripts rely on MECM-specific configurations or registry keys.

## Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/Warex2020/mecm-scripts.git
   ```
2. Navigate to the script you wish to execute.
3. Run the script with appropriate permissions in PowerShell.
   ```powershell
   .\ScriptName.ps1
   ```

## Contribution
Feel free to submit pull requests or open issues for bugs, feature requests, or improvements.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

---

**Maintainer:** Warex2020

For more information, visit the [GitHub repository](https://github.com/Warex2020/mecm-scripts/tree/main).

