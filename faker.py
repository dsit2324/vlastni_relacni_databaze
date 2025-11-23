from faker import Faker
import random
from datetime import timedelta

fake = Faker()

# ----------------------------
# SETTINGS
# ----------------------------
NUM_PLAYERS = 50
NUM_CARDS = 40
NUM_PLAYER_CARDS = 200
NUM_BATTLES = 100
NUM_ARENAS = 10
NUM_CLANS = 8

# ----------------------------
# GENERATE ARENAS
# ----------------------------
arenas = []
min_bw = 0
for i in range(1, NUM_ARENAS + 1):
    max_bw = min_bw + random.randint(50, 200)
    arenas.append({
        "arena_id": i,
        "name": f"Arena {i}",
        "min_battles_won": min_bw,
        "max_battles_won": max_bw
    })
    min_bw = max_bw + 1

# ----------------------------
# GENERATE CLANS
# ----------------------------
clans = [{
    "clan_id": i,
    "name": fake.word().title() + " Clan",
    "created_at": fake.date_time_this_decade()
} for i in range(1, NUM_CLANS + 1)]

# ----------------------------
# GENERATE PLAYERS
# ----------------------------
players = []
for i in range(1, NUM_PLAYERS + 1):
    battles_won = random.randint(0, 1000)
    
    # arena selection by battles_won
    arena = next(a["arena_id"] for a in arenas 
                 if a["min_battles_won"] <= battles_won <= a["max_battles_won"])
    
    clan = random.choice(clans)["clan_id"] if random.random() < 0.7 else None
    
    players.append({
        "player_id": i,
        "username": fake.user_name(),
        "battles_won": battles_won,
        "arena_id": arena,
        "clan_id": clan,
        "created_at": fake.date_time_this_year()
    })

# ----------------------------
# GENERATE CARDS
# ----------------------------
RARITIES = ['common', 'rare', 'epic', 'legendary']
TYPES = ['troop', 'spell', 'building']

cards = [{
    "card_id": i,
    "name": fake.word().title(),
    "description": fake.sentence(),
    "rarity": random.choice(RARITIES),
    "elixircost": random.randint(1, 10),
    "type": random.choice(TYPES)
} for i in range(1, NUM_CARDS + 1)]

# ----------------------------
# GENERATE PLAYERS_CARDS
# ----------------------------
players_cards = set()
while len(players_cards) < NUM_PLAYER_CARDS:
    players_cards.add((
        random.randint(1, NUM_PLAYERS),
        random.randint(1, NUM_CARDS),
        random.randint(1, 14)   # card level
    ))

players_cards = [
    {"player_id": p, "card_id": c, "level": lvl}
    for (p, c, lvl) in players_cards
]

# ----------------------------
# GENERATE BATTLES
# ----------------------------
battles = []
for i in range(1, NUM_BATTLES + 1):
    p1, p2 = random.sample(range(1, NUM_PLAYERS + 1), 2)
    winner = random.choice([p1, p2])
    length = random.randint(60, 300)  # duration seconds

    battles.append({
        "battle_id": i,
        "player1_id": p1,
        "player2_id": p2,
        "winner_id": winner,
        "played_at": fake.date_time_this_year(),
        "duration": length
    })

# ----------------------------
# PRINT SQL INSERT STATEMENTS
# ----------------------------

def sql_value(v):
    return "NULL" if v is None else f"'{v}'"

print("\n-- ARENAS")
for a in arenas:
    print(f"INSERT INTO arenas VALUES ({a['arena_id']}, '{a['name']}', {a['min_battles_won']}, {a['max_battles_won']});")

print("\n-- CLANS")
for c in clans:
    print(f"INSERT INTO clans VALUES ({c['clan_id']}, '{c['name']}', '{c['created_at']}');")

print("\n-- PLAYERS")
for p in players:
    print(f"INSERT INTO players VALUES ({p['player_id']}, '{p['username']}', {p['battles_won']}, {p['arena_id']}, {sql_value(p['clan_id'])}, '{p['created_at']}');")

print("\n-- CARDS")
for c in cards:
    print(f"INSERT INTO cards VALUES ({c['card_id']}, '{c['name']}', '{c['description']}', '{c['rarity']}', {c['elixircost']}, '{c['type']}');")

print("\n-- PLAYERS_CARDS")
for pc in players_cards:
    print(f"INSERT INTO players_cards VALUES ({pc['player_id']}, {pc['card_id']}, {pc['level']});")

print("\n-- BATTLES")
for b in battles:
    print(f"INSERT INTO battles VALUES ({b['battle_id']}, {b['player1_id']}, {b['player2_id']}, {b['winner_id']}, '{b['played_at']}', {b['duration']});")
