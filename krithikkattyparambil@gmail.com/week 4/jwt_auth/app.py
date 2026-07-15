from fastapi import FastAPI, Header

from database import users

from models import LoginRequest

from auth import create_token, verify_token

app = FastAPI(
    title="CTS JWT Authentication"
)


@app.get("/")
def home():

    return {
        "message": "JWT Authentication Demo"
    }


@app.post("/login")
def login(user: LoginRequest):

    db_user = users.get(user.username)

    if db_user is None:

        return {
            "message": "Invalid Username"
        }

    if db_user["password"] != user.password:

        return {
            "message": "Invalid Password"
        }

    token = create_token(user.username)

    return {
        "access_token": token
    }


@app.get("/protected")
def protected(authorization: str = Header(None)):

    if authorization is None:

        return {
            "message": "Token Missing"
        }

    token = authorization.replace("Bearer ", "")

    payload = verify_token(token)

    if payload is None:

        return {
            "message": "Invalid Token"
        }

    return {
        "message": "Protected Route Accessed",
        "user": payload["sub"]
    }


@app.post("/logout")
def logout():

    return {
        "message": "Logout Successful"
    }