import requests
from secretHitler.exceptions import UsernameTaken
import gql
from gql.transport.requests import RequestsHTTPTransport
from .globals import userAgent


class SecretHitler:
    """Main Secret Hitler class for handling all games and players

    Parameters
    ----------
    apiBaseUrl: `str`
        base url of your Secret Hitler web API server.
        eg. `http://localhost:8000`
    cleanup: `Optional[bool]`
        if handler should cleanup when being deconstructed, defaults to True
    """
    def __init__(self, apiBaseUrl: str, cleanup: bool = True):
        if not apiBaseUrl.endswith("/"):
            apiBaseUrl += "/"
        self.apiBaseUrl = apiBaseUrl
        self.players: list[Player] = []
        self.slots = []

        self.cleanup = cleanup

    def request(self, method: str | bytes, url: str, **kwargs):
        """Function to make requests to the web API.

        Parameters
        ----------
        method : `Union[str, bytes]`
            HTTP request method
        url : :class:`str`
            request endpoint
        **kwargs
            request options

        Returns
        -------
        `requests.Response` object for your request
        """
        kwargs["headers"] = kwargs.setdefault("headers", {})
        kwargs["headers"]["User-Agent"] = userAgent
        return requests.request(
            method=method,
            url=self.apiBaseUrl+url,
            **kwargs
        )

    def newPlayer(self, username: str):
        """Registers new player to the API.

        Parameters
        ----------
        username: `str`
            Username of new player

        Raises
        ------
        `secretHitler.UsernameTaken`
            if the username is already taken

        Returns
        -------
        `Player` object of the newly registered player.
        """
        playerJson = requests.post(
            f"{self.apiBaseUrl}auth/anonymous",
            json={"username": username},
            headers={"Content-Type": "application/json"}
        )
        if playerJson.status_code == 401:
            raise UsernameTaken(username)
        player = Player.fromJson(self, playerJson.json())
        self.players.append(player)
        return self.players[-1]

    def createSlot(self, player):
        """Creates new slot for games.

        Parameters
        ----------
        player: `Player`
            Admin of slot

        Returns
        -------
        

        """
        query = """
            mutation{
                createSlot(players: 5){
                    uuid
                }
            }
        """
        return player.query(query)

    def __del__(self):
        if not self.cleanup:
            return
        for player in self.players:
            player.delete()


class Player:
    """Player class for Secret Hitler.

    Used to handel players.

    Parameters
    ----------
    secretHitler: `SecretHitler`
        Game handeler
    id_: `str`
        Id of player
    username: `str`
        Player username
    token: `str`
        Player API token
    """
    def __init__(
        self,
        secretHitler: SecretHitler,
        id_: str,
        username: str,
        token: str
    ):
        self.secretHitler = secretHitler
        self.id = id_
        self.username = username
        self.token = token
        self.transport = RequestsHTTPTransport(
            url=f"{secretHitler.apiBaseUrl}graphql/v1",
            headers={"Authorization": self.token}
        )
        self.gqlClient = gql.Client(transport=self.transport)

    def request(self, method: str | bytes, url: str, **kwargs):
        """Function for API calls to web API.

        Parameters
        ----------
        method: `Union[str, bytes]`
            HTTP method
        url: `str`
            API endpoint
        **kwargs
            Request options
        """
        kwargs["headers"] = kwargs.setdefault("headers", {})
        kwargs["headers"]["Authorization"] = self.token
        return self.secretHitler.request(method, url, **kwargs)

    def query(self, query: str):
        """Function to execute GrahphQL queries to web API.

        Parameters
        ----------
        query: `str`
            GraphQL query

        """
        q = gql.gql(query)
        return self.gqlClient.execute(q)

    def delete(self):
        """Function to delete (unregister) player from web API.
        """
        r = self.request("DELETE", "auth", json={"token": self.id})
        print(r.status_code, r.text, r.url)

    def createSlot(self):
        """Function to create game slot with self as admin.
        """
        return self.secretHitler.createSlot(self)

    @classmethod
    def fromJson(cls, secretHitler: SecretHitler, jsonData: dict[str, str]):
        """Classmethod to construct `Player` from json response.

        Parameters
        ----------
        secretHitler: `SecretHitler`
            Game handeler
        jsonData: `dict[str, str]`
            JSON data from API response

        Returns
        -------
        `Player`
        """
        return cls(
            secretHitler,
            jsonData["id"],
            jsonData["nickname"],
            jsonData["token"]
        )


# class Slot:
#     def __init__(self, uuid, inGame, admin, )
