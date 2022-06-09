use std::borrow::BorrowMut;
use std::sync::{Arc, RwLock};
use uuid::Uuid;
use crate::app::{game::game::Game, user::user::User};

#[derive(Clone)]
pub struct Slot {
    data: Arc<RwLock<SlotInner>>
}

struct SlotInner {
    uuid: Uuid,
    admin: User,
    players: Vec<User>,
    players_count: u8,
    game: Option<Game> // Some - in-game | None - not playing
}

impl Slot {
    pub fn new(uuid: Uuid, admin: &User, players: u8) -> Result<Self, ()> {
        Ok(
            Self {
                data: Arc::new(
                    RwLock::new(
                        SlotInner {
                            uuid,
                            admin: admin.clone(),
                            players: Vec::with_capacity(players as usize),
                            players_count: players,
                            game: None
                        }
                    )
                )
            }
        )
    }

    pub fn uuid(&self) -> Result<Uuid, ()> {
        match self.data.read() {
            Ok(data) => Ok(data.uuid.clone()),
            Err(_) => Err(())
        }
    }

    pub fn in_game(&self) -> Result<bool, ()> {
        match self.data.read() {
            Ok(data) => Ok(data.game.is_some()),
            Err(_) => Err(())
        }
    }

    ///TODO: Implement error handling.
    pub fn start_game(&self) -> Result<(), ()> {
        match self.data.write() {
            Ok(mut data) => {
                if data.players_count as usize != data.players.iter().count() {
                    return Err(());
                }

                let game = Game::new(&data.players)?;
                data.game = Some(game);
                Ok(())
            },
            Err(_) => Err(())
        }
    }

    ///TODO: Implement error handling.
    pub fn stop_game(&self) -> Result<(), ()> {
        match self.data.write() {
            Ok(mut data) => {
                let game = data.game.borrow_mut();
                if let Some(game) = game {
                    game.stop();
                    data.game = None;
                }

                Err(())
            },
            Err(_) => Err(())
        }
    }

    ///TODO: Implement error handling.
    pub fn add_player(&self, user: User) -> Result<(), ()> {
        match self.data.write() {
            Ok(mut data) => {
                if data.players_count == data.players.iter().count() as u8 {
                    return Err(());
                }

                data.players.push(user);

                Ok(())
            },
            Err(_) => Err(())
        }
    }

    //TODO: Implement error handling.
    pub fn players(&self) -> Result<Vec<User>, ()> {
        self.data.read().map_err(|_| ()).map(|data| data.players.clone())
    }

    //TODO: Implement error handling.
    pub fn admin(&self) -> Result<User, ()> {
        self.data.read().map_err(|_| ()).map(|data| data.admin.clone())
    }
}
