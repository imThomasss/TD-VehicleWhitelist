CREATE TABLE IF NOT EXISTS vehicle_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(255) NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    player_discord_id VARCHAR(255) NOT NULL,
    vehicle_spawn_code VARCHAR(255) NOT NULL,
    UNIQUE KEY (player_id, vehicle_spawn_code)
);

-- Sample data
INSERT INTO vehicle_permissions (player_id, player_name, player_discord_id, vehicle_spawn_code) VALUES 
('player_cfx_id1', 'Player 1', 'discord_id_1', 'spawn_code1'),
('player_cfx_id2', 'Player 2', 'discord_id_2', 'spawn_code1'),
('player_cfx_id3', 'Player 3', 'discord_id_3', 'spawn_code2'),
('player_cfx_id4', 'Player 4', 'discord_id_4', 'spawn_code2');
