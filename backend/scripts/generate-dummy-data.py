#!/usr/bin/env python3
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

user = make_users()
players = make_players()
leagues = make_leagues()
games = make_games(leagues)
teammates = make_teammates(leagues, players)
scores = make_scores(leagues, games, teammates)
attendance = make_attendance(games, teammates)
