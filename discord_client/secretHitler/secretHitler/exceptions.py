class UsernameTaken(BaseException):
    def __init__(self, username):
        self.u = username
    def __str__(self):
        return f"Username {self.u} is already taken. Use another one."