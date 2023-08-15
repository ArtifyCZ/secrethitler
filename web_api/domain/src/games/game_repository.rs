use crate::games::Game;
use crate::Result;
use std::sync::Mutex;
use uuid::Uuid;

pub trait GameRepository {
    fn find_by_id(&self, id: Uuid) -> Result<Option<Game>>;

    fn save(&self, game: &Game) -> Result<()>;
}

pub use in_memory::InMemoryGameRepository;

mod in_memory {
    use super::*;

    #[derive(Default, Debug)]
    pub struct InMemoryGameRepository {
        games: Mutex<Vec<Game>>,
    }

    impl GameRepository for InMemoryGameRepository {
        fn find_by_id(&self, id: Uuid) -> Result<Option<Game>> {
            let games = self.games.lock().unwrap();
            Ok(games.iter().find(|g| g.id == id).map(Game::clone))
        }

        fn save(&self, game: &Game) -> Result<()> {
            let mut games = self.games.lock().unwrap();
            if let Some(index) = games.iter().position(|g| g.id == game.id) {
                games[index] = game.clone();
            } else {
                games.push(game.clone());
            }
            Ok(())
        }
    }
}
