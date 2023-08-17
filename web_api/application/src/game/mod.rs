mod create_game;

pub use create_game::*;
use secrethitler_domain::games::GameRepository;

pub struct GameService<'a> {
    game_repository: &'a dyn GameRepository,
}

impl<'a> GameService<'a> {
    pub fn new(game_repository: &'a dyn GameRepository) -> Self {
        Self { game_repository }
    }
}

#[cfg(test)]
pub(crate) mod mock {
    use super::*;
    use secrethitler_dal_temp::games::GameRepositoryInMemory;

    pub struct GameServiceInMemory {
        pub game_repository: GameRepositoryInMemory,
    }

    impl GameServiceInMemory {
        pub fn new() -> Self {
            let game_repository = GameRepositoryInMemory::default();

            Self { game_repository }
        }

        pub fn service(&self) -> GameService {
            GameService::new(&self.game_repository)
        }
    }
}
