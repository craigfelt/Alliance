#!/bin/bash

# Alliance Property Management System - Database Setup Script

echo "🏢 Alliance Property Management System - Database Setup"
echo "========================================================"

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

# Database configuration
DB_NAME="alliance_property"
DB_USER="${DB_USER:-postgres}"

echo ""
echo "📊 Database Configuration:"
echo "   Database: $DB_NAME"
echo "   User: $DB_USER"
echo ""

# Check if database exists
if psql -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "⚠️  Database '$DB_NAME' already exists."
    read -p "Do you want to drop and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Dropping existing database..."
        dropdb -U $DB_USER $DB_NAME
    else
        echo "ℹ️  Keeping existing database. Exiting..."
        exit 0
    fi
fi

# Create database
echo "🔨 Creating database '$DB_NAME'..."
createdb -U $DB_USER $DB_NAME

if [ $? -eq 0 ]; then
    echo "✅ Database created successfully"
else
    echo "❌ Failed to create database"
    exit 1
fi

# Run schema
echo "📝 Running database schema..."
psql -U $DB_USER -d $DB_NAME -f database/schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Schema applied successfully"
else
    echo "❌ Failed to apply schema"
    exit 1
fi

echo ""
echo "🎉 Database setup completed successfully!"
echo ""
echo "📋 Default login credentials:"
echo "   Email: admin@alliance.co.za"
echo "   Password: admin123"
echo ""
echo "⚠️  Remember to change these credentials after first login!"
echo ""
