# Quick Reference: Agent Workflow

## 🎯 The Simple Process

```
1. Request Change → 2. Accept Files → 3. Run Commands (if asked) → 4. Test → Done!
```

## 📋 Step-by-Step

### 1️⃣ Request Your Change
Tell the agent what you need:
- "Fix the login error"
- "Add a new feature"
- "Update the database"

### 2️⃣ Review & Accept
- Agent shows you changed files
- Click **Accept** on files that look good
- You can accept all at once or one by one

### 3️⃣ Run Commands (Only if Agent Asks)
If agent says "Run this command:", do it:
```bash
npm install
node db-setup-sqlite.js
npm run dev
```

### 4️⃣ Test Your App
- Restart servers if needed
- Test the functionality
- Report any errors to agent

## ❌ You DON'T Need To:
- ❌ Say "keep" for each file
- ❌ Click "Create PR" manually
- ❌ Manually configure things
- ❌ Read setup files unless there's an issue

## ✅ You DO Need To:
- ✅ Accept file changes
- ✅ Run commands agent asks for
- ✅ Test your app
- ✅ Report errors

## 🔄 Common Scenarios

| Scenario | What You Do |
|----------|-------------|
| Code changes | Accept files → Test |
| New package | Accept files → `npm install` → Test |
| Database setup | Accept files → Run setup script → Test |
| Config changes | Accept files → Restart server → Test |

## 💡 Remember
**The agent handles most setup automatically. You just need to accept changes and test!**

For detailed workflow, see [AGENT_WORKFLOW.md](AGENT_WORKFLOW.md)

