use crate::app::{game::player::Player, user::user::User};

pub struct Game {
    players: Vec<Player>
}

impl Game {
    //TODO: Implement error handling.
    pub fn new(players: &Vec<User>) -> Result<Self, ()> {
        match players.iter().count() {
            5..=10 => {
                Ok(Self {
                    players: Vec::new() //TODO: Implement role assignment and setting players.
                })
             }
            _ => Err(())
        }
    }

    pub fn stop(&mut self) {
        todo!("Implement game stopping.")
    }
}
