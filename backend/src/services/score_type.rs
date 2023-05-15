use actix_web::{
    get,
    web::{Data, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::{
    state::AppState,
    enums::{Sport, ScoreName}
};

#[derive(Serialize, FromRow, Deserialize)]
pub struct ScoreType {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub value: i32,
    pub sport: Sport,
    pub name: ScoreName,
}

#[get("/score_types/{sport}")]
pub async fn fetch_score_types(state: Data<AppState>, path: Path<Sport>) -> impl Responder {
    let sport = path.into_inner();
    let res: Result<Vec<ScoreType>, _> = query_as("SELECT * FROM score_type WHERE sport = $1")
        .bind(&sport)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(score_types) => HttpResponse::Ok().json(score_types),
        Err(e) => { println!("{}", e); HttpResponse::NotFound().json(&format!("No score_types found for sport '{sport}'")) },
    }
}
