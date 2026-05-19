import pyodbc
import os
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    """
    Creates and returns a SQL Server database connection.

    Note:
    Replace YOUR_SERVER_NAME with your local or development SQL Server instance.
    Do not commit real production server names or credentials.
    """

    server = os.getenv("DB_SERVER")
    database = os.getenv("DB_NAME")
    connection_string = (
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"Trusted_Connection=yes;"
    )

    try:
        connection = pyodbc.connect(connection_string)
        print("Database connection established successfully.")
        return connection
    except pyodbc.Error as e:
        print("Error connecting to the database:", e)
        return None

if __name__ == "__main__":
    conn = get_connection()

    if conn:
        print("Connection test passed.")
        conn.close()
    else:
        print("Connection test failed.")