import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Determine database type from environment variable, default to SQLite
const DB_TYPE = process.env.DB_TYPE || 'sqlite';

let db;
let isSQLite = false;

if (DB_TYPE === 'postgresql' || DB_TYPE === 'postgres') {
  // PostgreSQL configuration
  const pg = await import('pg');
  const { Pool } = pg.default;
  
  db = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'alliance_property',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
  });

  // Test the connection
  db.on('connect', () => {
    console.log('✅ PostgreSQL database connected successfully');
  });

  db.on('error', (err) => {
    console.error('❌ Unexpected error on idle database client', err);
    process.exit(-1);
  });
} else {
  // SQLite configuration (default)
  const Database = (await import('better-sqlite3')).default;
  const dbPath = process.env.DB_PATH || path.join(__dirname, '../../..', 'alliance_property.db');
  
  const sqliteDb = new Database(dbPath);
  
  // Enable foreign keys
  sqliteDb.pragma('foreign_keys = ON');
  
  isSQLite = true;
  console.log('✅ SQLite database connected successfully');
  console.log(`📁 Database file: ${dbPath}`);
  
  // Helper function to convert PostgreSQL parameterized queries to SQLite
  const convertQuery = (text, params) => {
    if (!params || params.length === 0) return { query: text, params: [] };
    
    let query = text;
    const newParams = [];
    
    // Replace $1, $2, etc. with ?
    query = query.replace(/\$(\d+)/g, (match, num) => {
      const index = parseInt(num) - 1;
      if (params[index] !== undefined) {
        newParams.push(params[index]);
        return '?';
      }
      return match;
    });
    
    // Convert ILIKE to LIKE with COLLATE NOCASE
    query = query.replace(/ILIKE/gi, 'LIKE');
    
    // Convert FILTER (WHERE ...) to CASE WHEN (SQLite doesn't support FILTER)
    // Handle COUNT(*) FILTER (WHERE condition)
    query = query.replace(/COUNT\(\*\)\s+FILTER\s+\(WHERE\s+([^)]+)\)/gi, 
      (match, condition) => {
        return `SUM(CASE WHEN ${condition} THEN 1 ELSE 0 END)`;
      });
    // Handle COUNT(expr) FILTER (WHERE condition)
    query = query.replace(/COUNT\(([^)]+)\)\s+FILTER\s+\(WHERE\s+([^)]+)\)/gi, 
      (match, expr, condition) => {
        return `SUM(CASE WHEN ${condition} THEN 1 ELSE 0 END)`;
      });
    
    // Convert DATE_TRUNC to SQLite strftime
    query = query.replace(/DATE_TRUNC\s*\(\s*'month'\s*,\s*([^)]+)\s*\)/gi, 
      (match, expr) => {
        return `strftime('%Y-%m', ${expr})`;
      });
    
    // Convert NOW() to CURRENT_TIMESTAMP
    query = query.replace(/\bNOW\(\)/gi, 'CURRENT_TIMESTAMP');
    
    return { query, params: newParams };
  };
  
  // Create a query method that matches PostgreSQL's async interface
  db = {
    query: async (text, params) => {
      try {
        const { query, params: sqliteParams } = convertQuery(text, params || []);
        
        // Check if it's a SELECT query
        const trimmedQuery = query.trim().toUpperCase();
        if (trimmedQuery.startsWith('SELECT')) {
          const stmt = sqliteDb.prepare(query);
          const result = stmt.all(sqliteParams);
          
          // Return result in PostgreSQL-like format
          return {
            rows: result,
            rowCount: result.length,
            command: 'SELECT',
          };
        } else {
          // For INSERT/UPDATE/DELETE, check if there's a RETURNING clause
          if (trimmedQuery.includes('RETURNING')) {
            // Split the query at RETURNING
            const parts = query.split(/RETURNING/i);
            const mainQuery = parts[0].trim();
            const returningClause = parts[1].trim();
            
            // Execute the main query
            const stmt = sqliteDb.prepare(mainQuery);
            const runResult = stmt.run(sqliteParams);
            
            // If it's an INSERT, get the inserted row
            if (trimmedQuery.startsWith('INSERT')) {
              const selectStmt = sqliteDb.prepare(
                `SELECT ${returningClause} FROM ${query.match(/INTO\s+(\w+)/i)?.[1] || 'users'} WHERE id = ?`
              );
              const insertedRow = selectStmt.get(runResult.lastInsertRowid);
              
              return {
                rows: insertedRow ? [insertedRow] : [],
                rowCount: 1,
                command: 'INSERT',
              };
            }
            
            return {
              rows: [],
              rowCount: runResult.changes,
              command: trimmedQuery.split(' ')[0],
            };
          } else {
            // Regular INSERT/UPDATE/DELETE without RETURNING
            const stmt = sqliteDb.prepare(query);
            const result = stmt.run(sqliteParams);
            
            return {
              rows: [],
              rowCount: result.changes,
              lastInsertRowid: result.lastInsertRowid,
              command: trimmedQuery.split(' ')[0],
            };
          }
        }
      } catch (error) {
        throw error;
      }
    },
    
    // Close method for cleanup
    close: () => sqliteDb.close(),
    
    // Expose the raw SQLite database for advanced operations
    _sqlite: sqliteDb,
  };
}

export default db;
