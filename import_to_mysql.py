import pandas as pd
import mysql.connector
from getpass import getpass

# Read CSV
df = pd.read_csv("Netflix_MySQL_Import.csv", encoding="ascii")

# Convert missing values to None
df = df.astype(object).where(pd.notna(df), None)

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password=getpass("Enter MySQL password: "),
    database="netflix_analytics"
)

cursor = conn.cursor()

# Insert only missing records
query = """
INSERT IGNORE INTO netflix_titles
(show_id, type, title, director, cast, country, date_added,
 release_year, rating, duration, listed_in, description)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

records = df.values.tolist()

cursor.executemany(query, records)
conn.commit()

print("New records inserted:", cursor.rowcount)

cursor.execute("SELECT COUNT(*) FROM netflix_titles")
print("Total records in MySQL:", cursor.fetchone()[0])

cursor.close()
conn.close()