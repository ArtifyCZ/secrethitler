import argparse
from . import SecretHitler

def register_func(args):
    player = SecretHitler(args.url, False).newPlayer(args.name)
    print({"token": player.token, "username": player.username, "id": player.id})

all_args = argparse.ArgumentParser()

subparsers = all_args.add_subparsers()
register: argparse.ArgumentParser = subparsers.add_parser("register", help="Register a user")
register.add_argument("name", type=str, help="username")
register.add_argument("url", type=str, help="baseurl")
register.set_defaults(func=register_func)

args = all_args.parse_args()
print(args.func(args))
print(args)