#!/bin/bash

# Create directories if they don't exist
mkdir -p web/sqlite3

# Download SQLite wasm files
curl -L https://github.com/sql-js/sql.js/releases/download/v1.8.0/sql-wasm.js -o web/sqlite3/sqlite3.js
curl -L https://github.com/sql-js/sql.js/releases/download/v1.8.0/sql-wasm.wasm -o web/sqlite3/sqlite3.wasm

# Make the script executable
chmod +x tool/setup_web.sh

echo "SQLite web files have been downloaded successfully!" 