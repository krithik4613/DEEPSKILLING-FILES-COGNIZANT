import unittest
from unittest.mock import patch
from api import fetch_user


class TestAPI(unittest.TestCase):

    @patch("api.requests.get")
    def test_fetch_user(self, mock_get):

        mock_get.return_value.json.return_value = {
            "id": 1,
            "name": "Mock API User"
        }

        result = fetch_user()

        self.assertEqual(result["id"], 1)
        self.assertEqual(result["name"], "Mock API User")

        mock_get.assert_called_once()


if __name__ == "__main__":
    unittest.main()