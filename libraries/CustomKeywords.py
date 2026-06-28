"""
CustomKeywords.py
-----------------
Custom Python keyword library for the Robot Framework Suite.
Provides utility keywords not covered by standard RF libraries.
"""
from robot.api.deco import keyword
from robot.api import logger
import time


class CustomKeywords:
    """Custom keyword library providing utility helpers."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_VERSION = "1.0.0"

    @keyword("Generate Random Email")
    def generate_random_email(self, domain: str = "test.com") -> str:
        """Generates a random email address using timestamp."""
        timestamp = int(time.time())
        email = f"user_{timestamp}@{domain}"
        logger.info(f"Generated email: {email}")
        return email

    @keyword("List Should Be Sorted Ascending")
    def list_should_be_sorted_ascending(self, values: list) -> None:
        """Asserts that a list of numeric values is in ascending order."""
        sorted_values = sorted(values)
        if values != sorted_values:
            raise AssertionError(
                f"List is not sorted ascending.\nActual:   {values}\nExpected: {sorted_values}"
            )
        logger.info(f"List is correctly sorted ascending: {values}")

    @keyword("List Should Be Sorted Descending")
    def list_should_be_sorted_descending(self, values: list) -> None:
        """Asserts that a list of numeric values is in descending order."""
        sorted_values = sorted(values, reverse=True)
        if values != sorted_values:
            raise AssertionError(
                f"List is not sorted descending.\nActual:   {values}\nExpected: {sorted_values}"
            )
        logger.info(f"List is correctly sorted descending: {values}")

    @keyword("Parse Price String To Float")
    def parse_price_string_to_float(self, price_string: str) -> float:
        """Converts a price string like '$29.99' to a float 29.99."""
        cleaned = price_string.replace("$", "").strip()
        return float(cleaned)

    @keyword("Log Test Info")
    def log_test_info(self, message: str) -> None:
        """Logs a formatted test info message."""
        logger.info(f"[TEST INFO] {message}", also_console=True)
