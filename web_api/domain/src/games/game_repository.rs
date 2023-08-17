use crate::games::Game;
use crate::Result;
use uuid::Uuid;

pub trait GameRepository {
    fn find_by_id(&self, id: Uuid) -> Result<Option<Game>>;

    fn save(&self, game: &Game) -> Result<()>;
}
