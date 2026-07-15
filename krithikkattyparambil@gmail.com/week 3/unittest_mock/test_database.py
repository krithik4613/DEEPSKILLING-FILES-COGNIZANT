import unittest
from unittest.mock import patch
from database import Database


class TestDatabase(unittest.TestCase):

    @patch.object(Database, "get_user")
    def test_get_user(self, mock_get_user):

        mock_get_user.return_value = {
            "id": 1,
            "name": "Mock User",
            "department": "Python"
        }

        db = Database()

        result = db.get_user(1)

        self.assertEqual(result["name"], "Mock User")
        self.assertEqual(result["department"], "Python")

        mock_get_user.assert_called_once_with(1)


if __name__ == "__main__":
    unittest.main()