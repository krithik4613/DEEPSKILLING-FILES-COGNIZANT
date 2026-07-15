class Database:

    def connect(self):
        return "Connected to Database"

    def get_user(self, user_id):
        return {
            "id": user_id,
            "name": "Abinithin",
            "department": "CSE"
        }