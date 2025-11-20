# Quick Download Scripts for Alliance Installer

## One-Line Download Commands

Copy and paste one of these commands into your terminal to quickly download the installer:

### Windows PowerShell
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craigfelt/Alliance/main/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

This downloads and runs the PowerShell installer in one command.

### Windows Command Prompt (Download Only)
```cmd
curl -o install.bat https://raw.githubusercontent.com/craigfelt/Alliance/main/install.bat && install.bat
```

### Linux/Mac (Download and Run)
```bash
curl -o install.sh https://raw.githubusercontent.com/craigfelt/Alliance/main/install.sh && chmod +x install.sh && ./install.sh
```

Or using wget:
```bash
wget https://raw.githubusercontent.com/craigfelt/Alliance/main/install.sh && chmod +x install.sh && ./install.sh
```

## Alternative: Clone Entire Repository

If you prefer to have all files:

```bash
git clone https://github.com/craigfelt/Alliance.git
cd Alliance
```

Then run the appropriate installer:
- Windows PowerShell: `.\install.ps1`
- Windows Batch: `.\install.bat`
- Linux/Mac: `./install.sh`

## Verify Download

After downloading, verify the file exists:

**Windows:**
```powershell
Get-FileHash install.ps1
```

**Linux/Mac:**
```bash
ls -lh install.sh
```

## Security Note

These scripts are downloaded from the official Alliance Property Management repository. Always verify you're downloading from the correct source:
- Repository: https://github.com/craigfelt/Alliance
- Direct file URLs: https://raw.githubusercontent.com/craigfelt/Alliance/main/install.*

---

For complete installation instructions, see [INSTALL.md](INSTALL.md) and [DOWNLOAD.md](DOWNLOAD.md).
