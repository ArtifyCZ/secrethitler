use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct Player {
    pub id: Uuid,
    pub name: String,
}

impl Player {
    pub fn create(name: String) -> Self {
        Self {
            id: Uuid::new_v4(),
            name,
        }
    }

    pub fn id(&self) -> Uuid {
        self.id
    }

    pub fn name(&self) -> &str {
        &self.name
    }
}
