"""
Greenfield Tool Library: Part 3 starter file.

Fill in every function. Do not rename anything in this file; the grading tests import these
names directly. Read the Part 3 section of the handout for the full specification.
"""
from datetime import date, timedelta
from decimal import Decimal

import mysql.connector

# Set this to the borrowing limit in your team's memo.
BORROWING_LIMIT = 0

# Graduate students only: a string that makes find_members_unsafe return every member.
INJECTION_PAYLOAD = ""


class LibraryError(Exception):
    """Base class for every business-rule error."""


class NotFound(LibraryError):
    pass


class MemberSuspended(LibraryError):
    pass


class ToolUnavailable(LibraryError):
    pass


class CertificationRequired(LibraryError):
    pass


class BorrowingLimitReached(LibraryError):
    pass


class AlreadyReturned(LibraryError):
    pass


def before_insert_hook():
    """Does nothing. Graduate students: call this in checkout_tool right before the INSERT."""
    pass


def find_members(conn, name_fragment):
    """Return [(member_id, first_name, last_name, email), ...] for members whose first or last name
    contains name_fragment, ignoring case, sorted by member_id."""
    raise NotImplementedError


def member_history(conn, member_id):
    """Return [(checkout_id, tool_name, checkout_date, due_date, return_date, late_fee), ...] sorted by
    checkout_date, then checkout_id. Raise NotFound if the member does not exist."""
    raise NotImplementedError


def checkout_tool(conn, member_id, tool_id, staff_id, checkout_date):
    """Check out a tool and return the new checkout_id. See the handout for the checks and their order."""
    raise NotImplementedError


def return_tool(conn, checkout_id, return_date):
    """Record a return, store the late fee, and return the fee as a Decimal."""
    raise NotImplementedError


def find_members_unsafe(conn, name_fragment):
    """Graduate students only: same as find_members, but vulnerable to SQL injection on purpose."""
    raise NotImplementedError
