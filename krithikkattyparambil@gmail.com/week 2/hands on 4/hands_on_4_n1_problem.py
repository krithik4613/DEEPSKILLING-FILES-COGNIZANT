"""
HANDS-ON 4 - Task 3: N+1 Query Problem demo
Requires: psycopg2-binary, a running college_db with sample data.
"""
import time
import psycopg2

conn = psycopg2.connect(dbname="college_db", user="postgres", password="postgres", host="localhost")


def n_plus_one_version():
    """1 query for enrollments, then 1 extra query per row -> N+1 total."""
    query_count = 0
    cur = conn.cursor()

    cur.execute("SELECT enrollment_id, student_id, course_id FROM enrollments")
    query_count += 1
    rows = cur.fetchall()

    results = []
    for enrollment_id, student_id, course_id in rows:
        cur.execute("SELECT first_name, last_name FROM students WHERE student_id = %s", (student_id,))
        query_count += 1
        student = cur.fetchone()
        results.append((enrollment_id, student))

    cur.close()
    print(f"{query_count} queries executed")
    return results


def fixed_join_version():
    """Single JOIN query -> 1 query total, no N+1."""
    cur = conn.cursor()
    cur.execute("""
        SELECT e.enrollment_id, s.first_name, s.last_name
        FROM enrollments e
        JOIN students s ON e.student_id = s.student_id
    """)
    results = cur.fetchall()
    cur.close()
    print("1 query executed")
    return results


if __name__ == "__main__":
    start = time.time()
    n_plus_one_version()
    print(f"N+1 version time: {time.time() - start:.4f}s")

    start = time.time()
    fixed_join_version()
    print(f"JOIN version time: {time.time() - start:.4f}s")

    conn.close()

# With 10,000 enrollments, the N+1 version would issue 10,001 queries
# instead of just 1 -> massive extra round-trip overhead.
