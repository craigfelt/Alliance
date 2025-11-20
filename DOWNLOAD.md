# How to Download and Run the Alliance Installer

## 📥 Downloading the Installer

You can download the installer files directly from the GitHub repository. Here are the methods:

### Method 1: Download Individual Files from GitHub

1. Go to the GitHub repository: https://github.com/craigfelt/Alliance
2. Navigate to the file you want to download:
   - For Windows PowerShell: Click on `install.ps1`
   - For Windows Batch: Click on `install.bat`
   - For Linux/Mac: Click on `install.sh`
3. Click the **"Raw"** button at the top right of the file content
4. Right-click on the page and select **"Save As..."** (or press Ctrl+S / Cmd+S)
5. Save the file to your desired location (e.g., Downloads folder)

### Method 2: Clone the Repository

If you have Git installed:

```bash
git clone https://github.com/craigfelt/Alliance.git
cd Alliance
```

Then run the appropriate installer for your platform.

📖 **For detailed cloning instructions, troubleshooting, and alternative methods, see [CLONE_SETUP.md](CLONE_SETUP.md)**

### Method 3: Download ZIP Archive

1. Go to the GitHub repository: https://github.com/craigfelt/Alliance
2. Click the green **"Code"** button
3. Select **"Download ZIP"**
4. Extract the ZIP file to your desired location
5. Navigate to the extracted folder

## 🖥️ Running the Installer

### Windows (PowerShell) - Recommended

1. Locate the downloaded `install.ps1` file
2. **Right-click** the file
3. Select **"Run with PowerShell"**

**If you get a security warning:**
- Open PowerShell as Administrator
- Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Try running the installer again

**Alternative method:**
- Open PowerShell in the folder containing the installer
- Run: `.\install.ps1`

### Windows (Batch File)

1. Locate the downloaded `install.bat` file
2. **Double-click** the file to run it
3. Follow the on-screen prompts

**Alternative method:**
- Open Command Prompt in the folder containing the installer
- Run: `install.bat`

### Linux/Mac (Shell Script)

1. Open Terminal
2. Navigate to the folder containing `install.sh`:
   ```bash
   cd ~/Downloads  # or wherever you downloaded it
   ```
3. Make the script executable:
   ```bash
   chmod +x install.sh
   ```
4. Run the installer:
   ```bash
   ./install.sh
   ```

**If using sudo for PostgreSQL:**
```bash
sudo ./install.sh
```

## 📋 What You'll Need

Before running the installer, make sure you have:

1. **Node.js 18+** installed
   - Download: https://nodejs.org/

2. **PostgreSQL 14+** installed
   - Windows: https://www.postgresql.org/download/windows/
   - Mac: https://postgresapp.com/ or `brew install postgresql@14`
   - Linux: `sudo apt-get install postgresql`

3. **Your PostgreSQL password** ready
   - You'll be prompted to enter it during installation

## 🎬 What Happens During Installation

The installer will:

1. ✅ Check if all prerequisites are installed
2. ✅ Install all Node.js dependencies (this may take a few minutes)
3. ✅ Create configuration files (.env)
4. ✅ Set up the PostgreSQL database
5. ✅ Apply the database schema
6. ✅ Give you instructions to start the application

## 🚀 After Installation

Once complete, you'll see instructions to:

1. **Start the backend** (in one terminal):
   ```bash
   cd backend
   npm run dev
   ```

2. **Start the frontend** (in another terminal):
   ```bash
   cd frontend
   npm run dev
   ```

3. **Access the app** at: http://localhost:5173
   - Email: admin@alliance.co.za
   - Password: admin123

## ⏱️ Expected Installation Time

- **Download time**: 1-5 minutes (depending on internet speed)
- **Installation time**: 5-10 minutes
- **Total**: About 15 minutes from start to finish

## 🔧 Troubleshooting Downloads

**"File won't download" or "Download blocked"**
- Your browser/antivirus may be blocking the download
- Try using Method 3 (Download ZIP Archive) instead
- Whitelist the GitHub domain in your security software

**"Can't find the downloaded file"**
- Check your Downloads folder
- Check your browser's download history (Ctrl+J in most browsers)

**"File has wrong extension" (like .txt instead of .ps1)**
- When saving, make sure to select "All Files" as the file type
- Manually rename the file to the correct extension

**"Windows says it can't run this file"**
- For .ps1 files, see the execution policy instructions above
- For .bat files, make sure you're not trying to open it with a text editor - double-click to run

## 📚 More Information

For complete installation instructions and troubleshooting, see:
- [INSTALL.md](INSTALL.md) - Complete installation guide
- [README.md](README.md) - Main documentation
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide

## 💡 Tips

- **Windows users**: PowerShell installer (install.ps1) is recommended for the best experience
- **Run as Administrator**: May be needed for some operations (especially database setup)
- **Stable internet**: Required for downloading dependencies
- **Close other apps**: To free up system resources during installation

## 🆘 Need Help?

If you encounter any issues:

1. Check [INSTALL.md](INSTALL.md) for detailed troubleshooting
2. Make sure all prerequisites are installed correctly
3. Try running the installer again
4. Contact support: support@alliance.co.za

---

Thank you for choosing Alliance Property Management System!
