use crate::games::Player;

#[derive(Clone, Debug)]
pub enum State {
    WaitingForPlayers { players: Vec<Player> },
    Running,
    Finished,
}
