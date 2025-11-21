# Restart Instructions - JWT_SECRET Fix

## ✅ What Was Changed
- Added `JWT_SECRET` to `backend/.env` file

## 🚀 What You Need To Do

### 1. Restart Backend Server
**If your backend is running:**
1. Go to the terminal where backend is running
2. Press `Ctrl + C` to stop it
3. Start it again:
   ```bash
   cd backend
   npm run dev
   ```

**If backend is NOT running:**
```bash
cd backend
npm run dev
```

### 2. Frontend (No Restart Needed)
The frontend doesn't need to be restarted - it's just making API calls.

### 3. Test Login
1. Go to your frontend (usually `http://localhost:5173`)
2. Try logging in with:
   - Email: `admin@alliance.co.za`
   - Password: `admin123`
3. Should work now! ✅

## ❌ You DON'T Need To:
- ❌ Create a PR
- ❌ Restart frontend
- ❌ Run any setup scripts
- ❌ Install anything

## ✅ That's It!
Just restart the backend and test login. The error should be fixed!

