from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()
random.seed(42)

# ===============================
# SETTINGS
# ===============================
NUM_PLAYERS = 50
NUM_CARDS = 40
NUM_PLAYER_CARDS = 200
NUM_BATTLES = 100
NUM_ARENAS = 10
NUM_CLANS = 8

# ===============================
# SQL HELPERS
# ===============================
def esc(s: str):
    """Escape apostrophes for SQL."""
    return s.replace("'", "''")

def sql(v):
    """Convert Python value to SQL value."""
    if v is None:
        return "NULL"
    if isinstance(v, str):
        return f"'{esc(v)}'"
    return str(v)

# ===============================
# GENERATE ARENAS
# ===============================
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

# ===============================
# GENERATE CLANS
# ===============================
clans = [{
    "clan_id": i,
    "name": fake.word().title() + " Clan",
    "created_at": fake.date_time_this_decade()
} for i in range(1, NUM_CLANS + 1)]

# ===============================
# GENERATE PLAYERS
# ===============================
players = []

for i in range(1, NUM_PLAYERS + 1):
    battles_won = random.randint(0, 1000)

    # find arena range
    arena = next(
        a["arena_id"] for a in arenas
        if a["min_battles_won"] <= battles_won <= a["max_battles_won"]
    )

    clan = random.choice(clans)["clan_id"] if random.random() < 0.7 else None

    players.append({
        "player_id": i,
        "username": fake.user_name(),
        "battles_won": battles_won,
        "arena_id": arena,
        "clan_id": clan,
        "created_at": fake.date_time_this_year()
    })

# ===============================
# GENERATE CARDS
# ===============================
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

# ===============================
# GENERATE PLAYERS_CARDS (bridge)
# ===============================
players_cards = set()

while len(players_cards) < NUM_PLAYER_CARDS:
    players_cards.add((
        random.randint(1, NUM_PLAYERS),
        random.randint(1, NUM_CARDS),
        random.randint(1, 14)
    ))

players_cards = [
    {"player_id": p, "card_id": c, "level": lvl}
    for (p, c, lvl) in players_cards
]

# ===============================
# GENERATE BATTLES
# ===============================
battles = []

for i in range(1, NUM_BATTLES + 1):
    p1, p2 = random.sample(range(1, NUM_PLAYERS + 1), 2)
    winner = random.choice([p1, p2])

    battles.append({
        "battle_id": i,
        "player1_id": p1,
        "player2_id": p2,
        "winner_id": winner,
        "played_at": fake.date_time_this_year(),
        "duration": random.randint(60, 300)
    })

# ===============================
# GENERATE SQL LINES
# ===============================
lines = []

def insert(table, row):
    columns = ", ".join(row.keys())
    values = ", ".join(sql(v) for v in row.values())
    lines.append(f"INSERT INTO {table} ({columns}) VALUES ({values});")

# --- ARENAS ---
lines.append("-- ARENAS")
for a in arenas:
    insert("arenas", a)

# --- CLANS ---
lines.append("\n-- CLANS")
for c in clans:
    insert("clans", c)

# --- PLAYERS ---
lines.append("\n-- PLAYERS")
for p in players:
    insert("players", p)

# --- CARDS ---
lines.append("\n-- CARDS")
for c in cards:
    insert("cards", c)

# --- PLAYERS_CARDS ---
lines.append("\n-- PLAYERS_CARDS")
for pc in players_cards:
    insert("players_cards", pc)

# --- BATTLES ---
lines.append("\n-- BATTLES")
for b in battles:
    insert("battles", b)

# ===============================
# WRITE TO SQL FILE
# ===============================
output_path = "clash_royale_data.sql"
with open(output_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"SQL soubor vytvořen: {output_path}")
