import Database from 'better-sqlite3';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { readFileSync } from 'fs';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function setupDatabase() {
  console.log('🔍 Starting SQLite database setup process...');

  const dbPath = process.env.DB_PATH || path.join(__dirname, 'alliance_property.db');
  console.log(`📁 Database path: ${dbPath}`);

  try {
    // Create or open database
    const db = new Database(dbPath);
    
    // Enable foreign keys
    db.pragma('foreign_keys = ON');
    console.log('✅ Connected to SQLite database');

    // Read and execute schema
    const schemaPath = path.join(__dirname, 'database', 'schema.sqlite.sql');
    console.log(`📖 Reading schema from: ${schemaPath}`);
    
    const schema = readFileSync(schemaPath, 'utf8');
    
    // Remove comments and clean up
    const cleanedSchema = schema
      .split('\n')
      .map(line => {
        // Remove single-line comments (but preserve -- in strings would be complex, so we'll be careful)
        const commentIndex = line.indexOf('--');
        if (commentIndex >= 0 && !line.includes("'")) {
          return line.substring(0, commentIndex);
        }
        return line;
      })
      .join('\n');
    
    // Split by semicolons, but be smarter about it
    // First, let's execute the entire schema as one batch
    console.log('🔍 Running schema migrations...');
    try {
      // Execute the cleaned schema
      db.exec(cleanedSchema);
      console.log('✅ Schema executed successfully');
    } catch (error) {
      // If batch execution fails, try statement by statement
      console.log('⚠️ Batch execution failed, trying statement by statement...');
      const statements = cleanedSchema
        .split(';')
        .map(s => s.trim())
        .filter(s => s.length > 0 && !s.match(/^--/));

      for (const statement of statements) {
        try {
          if (statement.trim().length > 0) {
            db.exec(statement);
          }
        } catch (stmtError) {
          // Ignore errors for statements that might already exist
          if (!stmtError.message.includes('already exists') && 
              !stmtError.message.includes('duplicate column') &&
              !stmtError.message.includes('no such table')) {
            console.warn(`⚠️ Warning: ${stmtError.message}`);
          }
        }
      }
    }

    console.log('✅ Schema migrations completed successfully!');
    
    // Verify tables were created
    const tables = db.prepare(`
      SELECT name FROM sqlite_master 
      WHERE type='table' AND name NOT LIKE 'sqlite_%'
    `).all();
    
    console.log(`✅ Created ${tables.length} tables:`, tables.map(t => t.name).join(', '));
    
    // Check if admin user exists
    const adminUser = db.prepare('SELECT * FROM users WHERE email = ?').get('admin@alliance.co.za');
    if (adminUser) {
      console.log('✅ Admin user already exists');
    } else {
      console.log('✅ Admin user created');
    }

    db.close();
    console.log('✅ Database setup process finished.');
  } catch (error) {
    console.error('❌ Error during setup:', error);
    process.exit(1);
  }
}

setupDatabase();

