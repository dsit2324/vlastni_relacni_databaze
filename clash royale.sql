CREATE TABLE `players` (
  `player_id` INT PRIMARY KEY,
  `username` VARCHAR(255),
  `battles_won` INT,
  `arena_id` INT,
  `clan_id` INT,
  `created_at` DATETIME
);

CREATE TABLE `cards` (
  `card_id` INT PRIMARY KEY,
  `name` VARCHAR(255),
  `description` TEXT,
  `rarity` ENUM('common','rare','epic','legendary'),
  `elixircost` INT,
  `type` ENUM('troop','spell','building')
);

CREATE TABLE `players_cards` (
  `player_id` INT,
  `card_id` INT,
  `level` INT,
  PRIMARY KEY (`player_id`, `card_id`)
);

CREATE TABLE `battles` (
  `battle_id` INT PRIMARY KEY,
  `player1_id` INT,
  `player2_id` INT,
  `winner_id` INT,
  `played_at` DATETIME,
  `duration` INT
);

CREATE TABLE `arenas` (
  `arena_id` INT PRIMARY KEY,
  `name` VARCHAR(255),
  `min_battles_won` INT,
  `max_battles_won` INT
);

CREATE TABLE `clans` (
  `clan_id` INT PRIMARY KEY,
  `name` VARCHAR(255),
  `created_at` DATETIME
);

ALTER TABLE `players` 
  ADD FOREIGN KEY (`arena_id`) REFERENCES `arenas` (`arena_id`);

ALTER TABLE `players` 
  ADD FOREIGN KEY (`clan_id`) REFERENCES `clans` (`clan_id`);

ALTER TABLE `players_cards` 
  ADD FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`);

ALTER TABLE `players_cards` 
  ADD FOREIGN KEY (`card_id`) REFERENCES `cards` (`card_id`);

ALTER TABLE `battles` 
  ADD FOREIGN KEY (`player1_id`) REFERENCES `players` (`player_id`);

ALTER TABLE `battles` 
  ADD FOREIGN KEY (`player2_id`) REFERENCES `players` (`player_id`);

ALTER TABLE `battles` 
  ADD FOREIGN KEY (`winner_id`) REFERENCES `players` (`player_id`);
