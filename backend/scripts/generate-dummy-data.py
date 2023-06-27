#!/usr/bin/env python3
from collections import defaultdict
from pprint import pprint
from random import sample, choice
from faker import Faker
from typing import Literal
from re import sub

fake = Faker()
fake.seed_instance(1)

score_types_ids = {
    "kickball": 1,
    "baseball": 2,
    "softball": 3,
}

def make_users() -> list[tuple[str, str, str, str, str]]:
    num_users = 5
    users = [
        (
            fake.name_nonbinary(),
            fake.free_email(),
            fake.unique.user_name(),
            fake.password(),
            fake.image_url(),
        )
        for _ in range(num_users)
    ]
    return users

def make_players() -> list[tuple[str, str, str, str, str, str, str, str, int, float | Literal["NULL"], int]]:
    # Starting players with 0 in score columns and we'll fill them in later
    num_players = 100
    players = [
        (
            fake.name_nonbinary(),
            choice(["man", "woman", "other"]),
            choice(["he/him", "she/her", "they/them"]),
            fake.date_of_birth(),
            fake.phone_number(),
            fake.free_email(),
            f"{fake.city()}, {fake.country()}",
            fake.image_url(),
            0,
            "NULL",
            0,
        )
        for _ in range(num_players)
    ]
    return players

def make_leagues() -> list[tuple[str, str, str, float, int, int, int, int]]:
    user_ids = range(1, 6)
    num_leagues_per_user = 3
    fake_season = lambda: choice(["Spring", "Summer", "Fall", "Winter"])
    fake_sport = lambda: choice(list(score_types_ids.keys()))
    fake_cost = lambda: fake.random_int(min=1, max=100) if fake.pybool(truth_probability=75) else 0
    fake_job = lambda: sub(r"[,(].*$", "", fake.job().lower())
    leagues = []
    for user_id in user_ids:
        for _ in range(num_leagues_per_user):
            sport = fake_sport()
            games_played = fake.random_int(min=0, max=10)
            games_won = fake.random_int(min=0, max=games_played)
            leagues.append((
                f"{fake.year()} {fake_season()} {sport[0].upper() + sport[1:]} League",
                f"The {fake.word(part_of_speech='adjective')} {fake_job()}s",
                sport,
                float(fake_cost()),
                user_id,
                games_won,
                games_played - games_won,
                games_played,
            ))
    return leagues

def make_games(
    leagues: list[tuple[str, str, str, float, int, int, int, int]],
) -> list[tuple[str, str, str, int, int, int, str]]:
    games = []
    fake_job = lambda: sub(r"[,(].*$", "", fake.job().lower())
    for i, league in enumerate(leagues):
        for _ in range(league[-1]):
            games.append((
                f"The {fake.word(part_of_speech='adjective')} {fake_job()}s",
                fake.address(),
                fake.iso8601(),
                i+1,
                fake.random_int(min=0, max=10),
                fake.random_int(min=0, max=10),
                fake.image_url(),
            ))
    return games

def make_teammates(
    leagues: list[tuple[str, str, str, float, int, int, int, int]],
    players: list[tuple[str, str, str, str, str, str, str, str, int, float | Literal["NULL"], int]]
) -> list[tuple[int, int, str]]:
    num_teammates = 200
    league_ids = range(1, len(leagues)+1)
    player_ids = range(1, len(players)+1)
    all_league_player_combos = [(league_id, player_id) for league_id in league_ids for player_id in player_ids]
    sampled_league_player_combos = sample(all_league_player_combos, num_teammates)
    random_paid = lambda combo: "NULL" if leagues[combo[0]-1][3] == 0 else choice(["TRUE", "FALSE"])
    teammates = [(*combo, random_paid(combo)) for combo in sampled_league_player_combos]
    return teammates

def make_scores(
    leagues: list[tuple[str, str, str, float, int, int, int, int]],
    games: list[tuple[str, str, str, int, int, int, str]],
    teammates: list[tuple[int, int, str]],
) -> list[tuple[int, int, int]]:
    scores = []
    for i, game in enumerate(games):
        players = [teammate for teammate in teammates if teammate[0] == game[3]]
        for _ in range(game[4]):
            scores.append((
                i+1,
                choice(players)[1],
                score_types_ids[leagues[game[3]-1][2]],
            ))
    return scores

def make_attendance(
    games: list[tuple[str, str, str, int, int, int, str]],
    teammates: list[tuple[int, int, str]],
) -> list[tuple[int, int]]:
    attendance = []
    for i, game in enumerate(games):
        players = [teammate for teammate in teammates if teammate[0] == game[3]]
        players_attended = [player for player in players if fake.pybool(truth_probability=75)]
        for player in players_attended:
            attendance.append((i+1, teammates.index(player)+1))
    return attendance

def to_sql() -> str:
    users = make_users()
    players = make_players()
    leagues = make_leagues()
    games = make_games(leagues)
    teammates = make_teammates(leagues, players)
    scores = make_scores(leagues, games, teammates)
    attendance = make_attendance(games, teammates)

    sql = ""
    sql += "INSERT INTO \"user\" (name, email, username, password_hash, avatar) VALUES\n"
    sql += ",\n".join([str(user) for user in users]) + ";\n"
    sql += "INSERT INTO player (name, gender, pronouns, birthday, phone, email, place_from, photo, score_all_time, score_avg_per_game, games_attended) VALUES\n"
    sql += ",\n".join([str(player) for player in players]) + ";\n"
    sql += "INSERT INTO league (name, team_name, sport, cost, captain_id, games_won, games_lost, games_played) VALUES\n"
    sql += ",\n".join([str(league) for league in leagues]) + ";\n"
    sql += "INSERT INTO game (opponent_name, game_location, start_datetime, league_id, your_score, opponent_score, group_photo) VALUES\n"
    sql += ",\n".join([str(game) for game in games]) + ";\n"
    sql += "INSERT INTO teammate (league_id, player_id, paid) VALUES\n"
    sql += ",\n".join([str(teammate) for teammate in teammates]) + ";\n"
    sql += "INSERT INTO score (player_id, game_id, score_type_id) VALUES\n"
    sql += ",\n".join([str(score) for score in scores]) + ";\n"
    sql += "INSERT INTO attendance (game_id, teammate_id) VALUES\n"
    sql += ",\n".join([str(attend) for attend in attendance]) + ";\n"

    counter = defaultdict(lambda: 0)
    for score in scores:
        counter[str(score[0])] += 1
    cases = " ".join([f"WHEN player_id = {key} THEN {value}" for key, value in counter.items()])
    sql += f"UPDATE player SET score_all_time = CASE {cases} ELSE score_all_time END;\n"

    counter = defaultdict(lambda: 0)
    for attend in attendance:
        counter[str(teammates[attend[1]-1][1])] += 1
    cases = " ".join([f"WHEN player_id = {key} THEN {value}" for key, value in counter.items()])
    sql += f"UPDATE player SET games_attended = CASE {cases} ELSE games_attended END;\n"

    sql += "UPDATE player SET score_avg_per_game = CAST(score_all_time AS REAL) / CAST(games_attended AS REAL);"

    return sql

with open("tests/data/dummy.sql", "w") as f:
    f.write(to_sql())
