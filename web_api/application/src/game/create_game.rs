use crate::game::GameService;
use secrethitler_domain::games::{Game, Player};
use uuid::Uuid;

pub struct CreateGameDto {
    pub username: String,
}

pub struct CreateGameOutputDto {
    pub player_id: Uuid,
    pub game_id: Uuid,
}

impl<'a> GameService<'a> {
    pub fn create_game(&self, input: CreateGameDto) -> anyhow::Result<CreateGameOutputDto> {
        let CreateGameDto { username } = input;
        let player = Player::create(username);
        let game = Game::create(vec![player.clone()]);
        self.game_repository.save(&game)?;
        Ok(CreateGameOutputDto {
            player_id: player.id(),
            game_id: game.id(),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::game::mock::GameServiceInMemory;
    use pretty_assertions::{assert_eq, assert_ne};

    #[test]
    fn create_valid_game() {
        let mock = GameServiceInMemory::new();
        let game_service = mock.service();
        let out = game_service
            .create_game(CreateGameDto {
                username: "test".to_string(),
            })
            .unwrap();
        let GameServiceInMemory { game_repository } = mock;
        let mut it = game_repository.into_iter();
        assert_ne!(out.game_id, Uuid::nil());
        assert_ne!(out.player_id, Uuid::nil());
        let game = it.next().unwrap();
        assert_eq!(game.id(), out.game_id);
    }
}
