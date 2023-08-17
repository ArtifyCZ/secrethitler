use secrethitler_domain::games::dto::GameDto;
use secrethitler_domain::games::{Game, GameRepository};
use secrethitler_domain::Result;
use std::sync::Mutex;

#[derive(Default)]
pub struct GameRepositoryInMemory {
    games: Mutex<Vec<GameDto>>,
}

impl IntoIterator for GameRepositoryInMemory {
    type Item = Game;
    type IntoIter = std::iter::Map<std::vec::IntoIter<GameDto>, fn(GameDto) -> Game>;

    fn into_iter(self) -> Self::IntoIter {
        self.games.into_inner().unwrap().into_iter().map(Game::from)
    }
}

impl GameRepository for GameRepositoryInMemory {
    fn find_by_id(&self, id: uuid::Uuid) -> Result<Option<Game>> {
        let games = self.games.lock().unwrap();
        let game = match games.iter().find(|game| game.id == id) {
            Some(x) => x,
            None => return Ok(None),
        };
        Ok(Some(game.clone().into()))
    }

    fn save(&self, game: &Game) -> Result<()> {
        let mut games = self.games.lock().unwrap();
        let game = GameDto::from(game.clone());
        let index = games.iter().position(|x| x.id == game.id);
        match index {
            Some(index) => games[index] = game,
            None => games.push(game),
        }
        Ok(())
    }
}
