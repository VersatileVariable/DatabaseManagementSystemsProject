"""
Public checks for Part 3. These do NOT change your database.
They confirm that your module imports, has the right names, and handles simple error cases.
The grading tests check much more.

Edit DB_CONFIG below, then run:   python test_public.py
"""
from datetime import date

import mysql.connector

import library_app as app

DB_CONFIG = dict(host="127.0.0.1", port=3306, user="root", password="", database="library")

passed = failed = 0


def check(label, fn):
    global passed, failed
    try:
        fn()
        print(f"PASS  {label}")
        passed += 1
    except Exception as e:
        print(f"FAIL  {label}: {type(e).__name__}: {e}")
        failed += 1


def raises(exc, fn, *args):
    try:
        fn(*args)
    except exc:
        return
    raise AssertionError(f"expected {exc.__name__}")


def closed(conn):
    assert not conn.in_transaction, "function returned with a transaction still open (commit or roll back)"


conn = mysql.connector.connect(**DB_CONFIG, autocommit=False)

check("required names exist", lambda: [getattr(app, n) for n in (
    "BORROWING_LIMIT", "NotFound", "MemberSuspended", "ToolUnavailable", "CertificationRequired",
    "BorrowingLimitReached", "AlreadyReturned", "find_members", "member_history", "checkout_tool", "return_tool")])
check("BORROWING_LIMIT is set from your memo", lambda: (_ for _ in ()).throw(AssertionError("still 0"))
      if app.BORROWING_LIMIT <= 0 else None)


def t_find():
    rows = app.find_members(conn, "a")
    assert isinstance(rows, list) and rows, "expected a non-empty list"
    assert all(len(r) == 4 for r in rows), "each row must be (member_id, first_name, last_name, email)"
    closed(conn)


check("find_members returns 4-column rows", t_find)
check("find_members accepts a quote", lambda: (app.find_members(conn, "O'"), closed(conn)))
check("member_history raises NotFound", lambda: (raises(app.NotFound, app.member_history, conn, 0), closed(conn)))
check("checkout_tool raises NotFound", lambda: (raises(app.NotFound, app.checkout_tool, conn, 0, 0, 0,
                                                       date(2026, 7, 1)), closed(conn)))
check("return_tool raises NotFound", lambda: (raises(app.NotFound, app.return_tool, conn, 0, date(2026, 7, 1)),
                                              closed(conn)))
conn.close()
print(f"\n{passed} passed, {failed} failed")
