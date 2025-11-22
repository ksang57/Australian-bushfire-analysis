"""
Test SQL Server connection from Python
"""
from db_config import test_connection, get_connection
import pandas as pd

print("=" * 50)
print("Testing SQL Server Connection")
print("=" * 50)

# Test basic connection
if test_connection():
    print("\n✅ Basic connection test passed!")
    
    # Test with pandas
    from db_config import get_sqlalchemy_engine
    engine = get_sqlalchemy_engine()
    
    query = "SELECT @@VERSION AS SQLVersion"
    df = pd.read_sql(query, engine)
    
    print("\n📊 Testing pandas integration:")
    print(f"SQL Server Version: {df['SQLVersion'][0][:80]}...")
    
    print("\n🎉 All tests passed! Ready to build your project!")
else:
    print("\n❌ Connection test failed!")
    print("Make sure Docker container is running: docker ps")
