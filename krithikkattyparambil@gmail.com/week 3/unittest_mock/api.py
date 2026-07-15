import requests


def fetch_user():
    response = requests.get("https://jsonplaceholder.typicode.com/users/1")
    return response.json()