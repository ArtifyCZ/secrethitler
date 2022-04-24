use std::collections::HashMap;
use std::sync::{Arc, LockResult, RwLock};
use uuid::Uuid;
use crate::app::slot::slot::Slot;
use crate::app::user::identity::Identity;

pub struct SlotService {
    data: Arc<RwLock<SlotServiceInner>>
}

struct SlotServiceInner {
    slots: HashMap<Uuid, Slot> // Slot's Uuid - Slot
}

impl SlotService {
    pub fn new() -> SlotService {
        Self {
            data: Arc::new(
                RwLock::new(
                    SlotServiceInner{
                        slots: HashMap::new()
                    }
                )
            )
        }
    }

    //TODO: Implement error handling for creating a slot.
    pub fn create_slot(&self, admin: &Identity, players: u8) -> Result<Slot, ()> {
        match players {
            5..=10 =>
                match self.data.write() {
                    Ok(mut data) => {
                        let slot = Slot::new(Uuid::new_v4(), admin.user(), players)?;
                        data.slots.insert(slot.uuid()?, slot.clone());
                        Ok(slot)
                    },
                    Err(_) => Err(())
                },
            _ => Err(())
        }
    }

    ///TODO: Implement error handling.
    pub fn find(&self, uuid: &Uuid) -> Result<Slot, ()> {
        match self.data.read() {
            Ok(data) => {
                let slot = data.slots.get(uuid).ok_or(())?.clone();
                Ok(slot)
            },
            Err(_) => Err(())
        }
    }
}

impl Clone for SlotService {
    fn clone(&self) -> Self {
        Self {
            data: self.data.clone()
        }
    }
}