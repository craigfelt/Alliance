# PowerShell Execution Policy - Troubleshooting Guide

## What is PowerShell Execution Policy?

PowerShell execution policy is a security feature in Windows that controls which scripts can run. By default, Windows prevents unsigned PowerShell scripts from running to protect against malicious code.

## Common Error Messages

If you see any of these errors when trying to run `install.ps1`:

```
File ... cannot be loaded. The file ... is not digitally signed. 
You cannot run this script on the current system.
```

```
... cannot be loaded because running scripts is disabled on this system.
```

```
UnauthorizedAccess
```

This means Windows is blocking the PowerShell script due to execution policy restrictions.

## Solutions (Easiest First)

### ⭐ Solution 1: Use install-powershell.bat (RECOMMENDED)

**This is the easiest and safest solution!**

1. Download [install-powershell.bat](https://raw.githubusercontent.com/craigfelt/Alliance/main/install-powershell.bat)
2. Double-click the file to run it
3. That's it! The launcher automatically bypasses execution policy for the installer only

**Why this works:** The `.bat` file runs PowerShell with the `-ExecutionPolicy Bypass` parameter, which allows the script to run without changing your system-wide settings.

**Download with PowerShell:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craigfelt/Alliance/main/install-powershell.bat" -OutFile "install-powershell.bat"
```

Then double-click `install-powershell.bat`

### Solution 2: Run with Bypass Parameter

Open PowerShell and run the installer with the bypass flag:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\install.ps1
```

**Why this works:** The `-ExecutionPolicy Bypass` parameter tells PowerShell to ignore execution policy for this one command only. It doesn't change your system settings.

### Solution 3: Use install.bat Instead

If you prefer not to use PowerShell at all:

1. Download [install.bat](https://raw.githubusercontent.com/craigfelt/Alliance/main/install.bat)
2. Double-click to run
3. This is a pure Command Prompt script (no PowerShell execution policy issues)

**Trade-off:** The batch version has less advanced features than the PowerShell version, but it works without any execution policy concerns.

### Solution 4: Change Execution Policy (Requires Admin)

**Warning:** This changes a security setting on your computer. Only do this if you understand the implications.

1. Open PowerShell **as Administrator** (right-click, "Run as Administrator")
2. Run this command:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Type `Y` and press Enter when prompted
4. Close PowerShell and run `install.ps1` normally

**What this does:** Changes your personal execution policy to allow local scripts to run. Remote scripts still need to be signed. This is a permanent change until you change it back.

**To revert later:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
```

## Understanding Execution Policy Levels

| Policy | Description |
|--------|-------------|
| **Restricted** | Default on Windows clients. No scripts can run. |
| **RemoteSigned** | Local scripts can run. Downloaded scripts must be signed. |
| **Unrestricted** | All scripts can run (shows warning for downloaded scripts). |
| **Bypass** | Nothing is blocked, no warnings. Used temporarily. |

## Why Not Just Sign the Script?

Code signing certificates cost money and require verification of identity. For an open-source project like this, using the bypass parameter or launcher is simpler and just as secure (since you're downloading the code from GitHub anyway).

## Security Considerations

- **install-powershell.bat** (Solution 1) and **-ExecutionPolicy Bypass** (Solution 2) only bypass the policy for that specific script run. They don't change your system settings.
- Always download scripts only from trusted sources (like the official GitHub repository)
- You can review the script content before running it: open `install.ps1` in a text editor
- The installer is open source - you can see exactly what it does

## Additional Resources

- [Microsoft Docs: About Execution Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
- [Microsoft Docs: Set-ExecutionPolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy)

## Still Having Issues?

If none of these solutions work:

1. Check the [INSTALL.md](INSTALL.md) troubleshooting section
2. Try using `install.bat` (Command Prompt version) instead
3. Consider manual installation - see [QUICKSTART.md](QUICKSTART.md)
4. Open an issue on GitHub with your error message

---

**Quick Reference:**

✅ **Easiest:** Use `install-powershell.bat`  
✅ **Quick:** Run with `powershell.exe -ExecutionPolicy Bypass -File .\install.ps1`  
⚠️ **Permanent:** Change policy with `Set-ExecutionPolicy RemoteSigned` (admin required)
