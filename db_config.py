"""
Database configuration for Bushfire Analysis project
"""
import pymssql
import pandas as pd
from sqlalchemy import create_engine

# SQL Server connection settings
DB_CONFIG = {
    'server': 'localhost',
    'port': 1433,
    'database': 'BushfireAnalysis',
    'username': 'sa',
    'password': 'BushfireAnalysis2024!'
}

def get_connection():
    """Returns pymssql connection object"""
    try:
        conn = pymssql.connect(
            server=DB_CONFIG['server'],
            port=DB_CONFIG['port'],
            user=DB_CONFIG['username'],
            password=DB_CONFIG['password'],
            database=DB_CONFIG['database']
        )
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

def get_sqlalchemy_engine():
    """Returns SQLAlchemy engine for pandas"""
    connection_string = (
        f"mssql+pymssql://{DB_CONFIG['username']}:{DB_CONFIG['password']}"
        f"@{DB_CONFIG['server']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
    )
    return create_engine(connection_string)

def test_connection():
    """Test database connection"""
    conn = get_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute("SELECT DB_NAME() AS CurrentDB, GETDATE() AS CurrentTime")
        result = cursor.fetchone()
        print(f"✅ Connected to database: {result[0]}")
        print(f"⏰ Server time: {result[1]}")
        conn.close()
        return True
    return False
