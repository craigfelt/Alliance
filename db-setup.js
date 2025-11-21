import pkg from 'pg';
import dotenv from 'dotenv';
import { exec } from 'child_process';
import path from 'path';

dotenv.config({ path: path.resolve('backend', '.env') });
const { Client } = pkg;

async function setupDatabase() {
  console.log('🔍 Starting database setup process...');

  const adminClient = new Client({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'admin123',
    port: process.env.DB_PORT || 5432,
    database: 'postgres'
  });

  try {
    console.log('📡 Connecting to PostgreSQL...');
    await adminClient.connect();
    console.log('✅ Connected successfully.');

    const dbName = process.env.DB_NAME || 'alliance_app';
    console.log(`🔍 Checking if database "${dbName}" exists...`);

    const checkResult = await adminClient.query(
      `SELECT 1 FROM pg_database WHERE datname = $1`,
      [dbName]
    );

    if (checkResult.rowCount === 0) {
      console.log(`⚠️ Database "${dbName}" does not exist. Creating...`);
      await adminClient.query(`CREATE DATABASE "${dbName}"`);
      console.log(`✅ Database "${dbName}" created successfully!`);
    } else {
      console.log(`✅ Database "${dbName}" already exists.`);
    }

    console.log('🔍 Running migrations...');
    await runMigrations();
    console.log('✅ Migrations completed successfully!');
  } catch (error) {
    console.error('❌ Error during setup:', error);
  } finally {
    await adminClient.end();
    console.log('✅ Database setup process finished.');
  }
}

function runMigrations() {
  return new Promise((resolve, reject) => {
    const migrationCommand = 'npm run migrate'; // Adjust for your ORM
    console.log(`🔍 Executing migration command: ${migrationCommand}`);

    exec(migrationCommand, (error, stdout, stderr) => {
      if (error) {
        console.error('❌ Migration failed:', stderr);
        return reject(error);
      }
      console.log('✅ Migration output:\n', stdout);
      resolve();
    });
  });
}

setupDatabase();