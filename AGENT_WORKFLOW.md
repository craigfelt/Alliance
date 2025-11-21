# AI Agent Workflow Guide

This guide explains the exact process to follow when requesting changes from the AI agent in Cursor.

## 📋 Standard Workflow

### Step 1: Request Your Changes
Simply tell the AI agent what you need:
- "Add a new feature..."
- "Fix this bug..."
- "Update the database..."
- "Change the UI..."

### Step 2: Review Changes (Automatic)
The AI agent will:
- ✅ Make the necessary code changes
- ✅ Show you what files were modified
- ✅ Explain what was done

### Step 3: Review File Changes
**You have 3 options for each file:**

1. **✅ Accept** - Click "Accept" if the changes look good
2. **❌ Reject** - Click "Reject" if you want to undo those changes
3. **✏️ Edit** - Make manual adjustments if needed

**You do NOT need to:**
- ❌ Say "keep" for each file
- ❌ Manually check every single file
- ❌ Click "Create PR" (unless you're using GitHub Copilot Agent)

### Step 4: Test Your Changes
After accepting changes:
1. **Restart your servers** (if backend/frontend were running)
2. **Test the functionality** to make sure it works
3. **Check for errors** in the console

### Step 5: Manual Configuration (If Needed)
**Only if the agent mentions it**, you may need to:
- Update `.env` files (usually done automatically)
- Run setup scripts (the agent will tell you)
- Install dependencies (usually automatic)

---

## 🔄 Different Scenarios

### Scenario A: Simple Code Changes
**Example:** "Change the button color to blue"

**Process:**
1. Agent makes changes
2. You review and accept
3. Test in browser
4. **Done!** ✅

**No manual config needed.**

---

### Scenario B: Database/Environment Changes
**Example:** "Switch to SQLite database"

**Process:**
1. Agent makes code changes
2. You accept the changes
3. **Agent may ask you to run a command** (like `node db-setup-sqlite.js`)
4. Follow the agent's instructions
5. Test the app

**Manual steps only if agent explicitly asks.**

---

### Scenario C: New Dependencies
**Example:** "Add a new package for charts"

**Process:**
1. Agent updates `package.json`
2. You accept the change
3. **Run:** `npm install` (in the affected directory)
4. Restart your server
5. Test

**You need to run `npm install` when dependencies change.**

---

## 🚨 Important Notes

### ✅ What You DON'T Need to Do:
- ❌ Manually review every single file change
- ❌ Say "keep" for each file
- ❌ Create PRs manually (unless using GitHub Copilot Agent)
- ❌ Manually configure things the agent already configured
- ❌ Read through setup files unless there's an issue

### ✅ What You DO Need to Do:
- ✅ Review the summary of changes
- ✅ Accept/reject changes that make sense
- ✅ Run commands the agent asks you to run
- ✅ Test your application after changes
- ✅ Report any errors back to the agent

---

## 📝 Quick Reference Checklist

When the agent makes changes:

- [ ] **Review the summary** - Agent explains what was done
- [ ] **Accept file changes** - Click accept on modified files
- [ ] **Run any commands** - If agent says "run this command..."
- [ ] **Restart servers** - If backend/frontend code changed
- [ ] **Test functionality** - Make sure it works
- [ ] **Report issues** - Tell agent if something doesn't work

---

## 🎯 Example Workflow

**You:** "I need to add user authentication"

**Agent:**
- Creates auth routes
- Updates database schema
- Adds login page
- Shows you 5 files changed

**You:**
1. Review the changes (looks good!)
2. Accept all 5 files
3. See agent message: "Run `node db-setup-sqlite.js`"
4. Run that command in terminal
5. Restart backend: `npm run dev`
6. Test login page
7. **Done!** ✅

---

## 🔧 When to Check Setup Files

**Only check setup files if:**
- ❌ Something isn't working
- ❌ Agent says "see QUICK_START_SQLITE.md"
- ❌ You're setting up for the first time
- ❌ You want to understand how something works

**Don't check setup files if:**
- ✅ Everything is working
- ✅ Agent already configured it
- ✅ You're just making small changes

---

## 💡 Pro Tips

1. **Trust the agent** - It usually handles configuration automatically
2. **Read error messages** - If something breaks, the error tells you what to fix
3. **Ask questions** - If unsure, just ask the agent
4. **Test immediately** - Don't wait, test right after changes
5. **One change at a time** - Don't request 10 things at once

---

## 🆘 Troubleshooting

### "Changes didn't work"
1. Check if you accepted all file changes
2. Restart your servers
3. Check console for errors
4. Tell the agent what error you see

### "I'm not sure what to do"
1. Read the agent's summary message
2. Look for commands it asks you to run
3. Ask the agent: "What do I need to do next?"

### "Too many files changed"
1. You can accept all at once (if you trust the changes)
2. Or review each file individually
3. The agent explains what each file does

---

## 📞 Summary

**TL;DR:**
1. Request changes from agent
2. Accept the file changes
3. Run any commands the agent mentions
4. Test your app
5. Done!

**You don't need to manually configure things unless the agent explicitly asks you to.**

The agent handles most setup automatically! 🎉

