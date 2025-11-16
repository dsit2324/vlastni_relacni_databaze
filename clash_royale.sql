
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `arenas` (
  `arena_id` int(2) NOT NULL,
  `name` varchar(20) NOT NULL,
  `min_battles_won` int(3) NOT NULL,
  `max_battles_won` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `arenas` (`arena_id`, `name`, `min_battles_won`, `max_battles_won`) VALUES
(1, 'Goblin Stadium', 0, 10),
(2, 'Bone Pit', 11, 20);

CREATE TABLE `battles` (
  `battle_id` int(10) UNSIGNED NOT NULL,
  `player1_id` int(10) NOT NULL,
  `player2_id` int(10) NOT NULL,
  `winner_id` int(10) DEFAULT NULL,
  `played_at` datetime DEFAULT NULL,
  `duration` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `battles` (`battle_id`, `player1_id`, `player2_id`, `winner_id`, `played_at`, `duration`) VALUES
(3, 1, 2, 1, '2025-11-13 17:33:14', 75),
(4, 1, 2, 1, '2025-11-15 17:33:14', 100);

CREATE TABLE `cards` (
  `card_id` int(3) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `rarity` enum('common','rare','epic','legendary') NOT NULL,
  `elixircost` int(1) UNSIGNED NOT NULL,
  `type` enum('troop','spell','building') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `cards` (`card_id`, `name`, `description`, `rarity`, `elixircost`, `type`) VALUES
(1, 'Mega Knight', 'Strongest card in the game.', 'legendary', 7, 'troop'),
(2, 'Fireball', 'A fireball that destroys everything.', 'rare', 4, 'spell');

CREATE TABLE `clans` (
  `clan_id` int(10) NOT NULL,
  `name` varchar(10) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `clans` (`clan_id`, `name`, `created_at`) VALUES
(1, 'IT', '2025-11-04 17:31:18'),
(2, 'SV', '2025-11-08 17:31:18');

CREATE TABLE `players` (
  `player_id` int(10) NOT NULL,
  `username` varchar(10) NOT NULL,
  `battles_won` int(5) UNSIGNED NOT NULL,
  `arena_id` int(2) NOT NULL,
  `clan_id` int(10) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `players` (`player_id`, `username`, `battles_won`, `arena_id`, `clan_id`, `created_at`) VALUES
(1, 'Dominik', 15, 2, NULL, '2025-11-09 17:27:38'),
(2, 'Honza', 7, 1, NULL, '2025-11-11 17:27:38');

CREATE TABLE `players_cards` (
  `player_id` int(10) NOT NULL,
  `card_id` int(3) NOT NULL,
  `level` int(2) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `players_cards` (`player_id`, `card_id`, `level`) VALUES
(1, 1, 15),
(2, 2, 9);

ALTER TABLE `arenas`
  ADD PRIMARY KEY (`arena_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `name_2` (`name`);

ALTER TABLE `battles`
  ADD PRIMARY KEY (`battle_id`),
  ADD KEY `player1_id` (`player1_id`),
  ADD KEY `player2_id` (`player2_id`),
  ADD KEY `winner_id` (`winner_id`);

ALTER TABLE `cards`
  ADD PRIMARY KEY (`card_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `name_2` (`name`),
  ADD KEY `rarity` (`rarity`),
  ADD KEY `type` (`type`);

ALTER TABLE `clans`
  ADD PRIMARY KEY (`clan_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `name_2` (`name`);

ALTER TABLE `players`
  ADD PRIMARY KEY (`player_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `arena_id` (`arena_id`),
  ADD KEY `clan_id` (`clan_id`),
  ADD KEY `username_2` (`username`);

ALTER TABLE `players_cards`
  ADD PRIMARY KEY (`player_id`,`card_id`),
  ADD KEY `card_id` (`card_id`);

ALTER TABLE `arenas`
  MODIFY `arena_id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `battles`
  MODIFY `battle_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `cards`
  MODIFY `card_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `clans`
  MODIFY `clan_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `players`
  MODIFY `player_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `battles`
  ADD CONSTRAINT `battles_ibfk_1` FOREIGN KEY (`player1_id`) REFERENCES `players` (`player_id`),
  ADD CONSTRAINT `battles_ibfk_2` FOREIGN KEY (`player2_id`) REFERENCES `players` (`player_id`),
  ADD CONSTRAINT `battles_ibfk_3` FOREIGN KEY (`winner_id`) REFERENCES `players` (`player_id`);

ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`arena_id`) REFERENCES `arenas` (`arena_id`),
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`clan_id`) REFERENCES `clans` (`clan_id`);

ALTER TABLE `players_cards`
  ADD CONSTRAINT `players_cards_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`),
  ADD CONSTRAINT `players_cards_ibfk_2` FOREIGN KEY (`card_id`) REFERENCES `cards` (`card_id`);
COMMIT;
