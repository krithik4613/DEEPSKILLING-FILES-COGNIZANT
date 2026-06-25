import mysql.connector
import time

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_PASSWORD",
    database="college_db"
)

cursor = conn.cursor()


start = time.time()

cursor.execute("SELECT student_id FROM enrollments")
enrollments = cursor.fetchall()

query_count = 1

for row in enrollments:
    sid = row[0]

    cursor.execute(
        "SELECT first_name,last_name FROM students WHERE student_id=%s",
        (sid,)
    )

    cursor.fetchone()
    query_count += 1

end = time.time()

print("\nN+1 VERSION")
print("Queries Executed:", query_count)
print("Time Taken:", end - start)


start = time.time()

cursor.execute("""
SELECT
e.enrollment_id,
s.first_name,
s.last_name
FROM enrollments e
JOIN students s
ON e.student_id=s.student_id
""")

cursor.fetchall()

end = time.time()

print("\nJOIN VERSION")
print("Queries Executed: 1")
print("Time Taken:", end - start)

cursor.close()
conn.close()