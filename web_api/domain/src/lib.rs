pub mod games;

pub type Result<T, E = anyhow::Error> = anyhow::Result<T, E>;
