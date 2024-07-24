CREATE TABLE IF NOT EXISTS vehicle_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(255) NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    player_discord_id VARCHAR(255) NOT NULL,
    vehicle_spawn_code VARCHAR(255) NOT NULL,
    UNIQUE KEY (player_id, vehicle_spawn_code)
);

