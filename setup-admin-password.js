import Database from 'better-sqlite3';
import path from 'path';
import { fileURLToPath } from 'url';
import { createRequire } from 'module';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const require = createRequire(import.meta.url);

// Import bcryptjs from backend node_modules
const bcrypt = require(path.join(__dirname, 'backend', 'node_modules', 'bcryptjs'));

const dbPath = path.join(__dirname, 'alliance_property.db');
const db = new Database(dbPath);

// Hash the admin password
const salt = await bcrypt.genSalt(10);
const hashedPassword = await bcrypt.hash('admin123', salt);

// Update admin user with hashed password
db.prepare('UPDATE users SET password = ? WHERE email = ?').run(hashedPassword, 'admin@alliance.co.za');

console.log('✅ Admin password hashed and updated successfully');

db.close();

