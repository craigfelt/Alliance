# Quick Restart Guide 🚀

After the AI agent makes changes, use these simple scripts to restart your servers.

## 📁 Available Scripts

### 🎯 Most Common (After Agent Changes)

| Script | When to Use | What It Does |
|--------|-------------|--------------|
| **`restart-backend-only.bat`** | After backend code changes or .env updates | Restarts backend in new window |
| **`restart-frontend-only.bat`** | After frontend code changes | Restarts frontend in new window |
| **`restart-both.bat`** | Starting fresh or major changes | Starts both servers in separate windows |

### 📋 Detailed Scripts

| Script | Description |
|--------|-------------|
| `restart-backend.bat` | Restarts backend (keeps window open) |
| `restart-frontend.bat` | Restarts frontend (keeps window open) |

## 🎯 Quick Workflow After Agent Changes

### Scenario 1: Backend Changes Only
1. Agent makes backend changes
2. You accept the files
3. **Double-click:** `restart-backend-only.bat`
4. ✅ Done! Test your app

### Scenario 2: Frontend Changes Only
1. Agent makes frontend changes
2. You accept the files
3. **Double-click:** `restart-frontend-only.bat`
4. ✅ Done! Test your app

### Scenario 3: Both Changed
1. Agent makes changes to both
2. You accept the files
3. **Double-click:** `restart-both.bat`
4. ✅ Done! Test your app

### Scenario 4: .env File Changed
1. Agent updates `.env` file
2. You accept the change
3. **Double-click:** `restart-backend-only.bat` (backend reads .env)
4. ✅ Done! Test your app

## 💡 Pro Tips

1. **Keep scripts on desktop** - Create shortcuts for easy access
2. **Use the "only" scripts** - They're faster and open in new windows
3. **Check the windows** - Scripts open new command windows so you can see logs
4. **Close windows to stop** - Just close the server windows to stop them

## 🔧 Creating Desktop Shortcuts

1. Right-click on `restart-backend-only.bat`
2. Select "Create shortcut"
3. Drag shortcut to desktop
4. Rename to "Restart Backend" (optional)
5. Repeat for `restart-frontend-only.bat`

Now you can double-click from desktop! 🎉

## 📝 What Each Script Does

### `restart-backend-only.bat`
- Stops any process on port 5000
- Starts backend in new window
- Quick and simple

### `restart-frontend-only.bat`
- Stops any process on port 5173
- Starts frontend in new window
- Quick and simple

### `restart-both.bat`
- Stops all Node processes
- Starts both servers in separate windows
- Use when starting fresh

## ⚠️ Troubleshooting

### "Port already in use"
- The script should handle this automatically
- If it doesn't, close the server windows manually first

### "npm not found"
- Make sure you're in the project root directory
- Run scripts from the main Alliance folder

### Scripts don't work
- Right-click script → "Run as administrator"
- Or open PowerShell and run: `.\restart-backend-only.bat`

## 🎯 Summary

**After agent changes:**
1. Accept file changes
2. Double-click the appropriate restart script
3. Test your app
4. Done! ✅

**That's it! No manual commands needed!**

