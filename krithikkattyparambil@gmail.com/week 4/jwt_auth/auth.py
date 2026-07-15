from jose import jwt

SECRET_KEY = "CTS_SECRET_KEY"

ALGORITHM = "HS256"


def create_token(username):

    token = jwt.encode(
        {"sub": username},
        SECRET_KEY,
        algorithm=ALGORITHM
    )

    return token


def verify_token(token):

    try:
        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )

        return payload

    except Exception:

        return None