
-- Copyright 2025 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


-- Smart NPC General
create schema if not exists "smartnpc";
create extension if not exists "vector";
GRANT USAGE ON SCHEMA smartnpc TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.world_background(
    background_id VARCHAR(1024) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    background_name TEXT DEFAULT NULL,
    content TEXT DEFAULT NULL,
    lore_level int DEFAULT 1,
    background_embeddings vector(768) NULL,
    background TEXT DEFAULT NULL
);
GRANT SELECT ON smartnpc.world_background TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.teams(
    team_id VARCHAR(256) PRIMARY KEY,
    team_name VARCHAR(36) DEFAULT NULL,
    team_year int,
    description TEXT DEFAULT NULL,
    roster TEXT DEFAULT NULL,
    default_lineup TEXT DEFAULT NULL
);
GRANT SELECT ON smartnpc.teams TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.scene(
    scene_id VARCHAR(1024) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    goal TEXT DEFAULT NULL,
    scene TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL,
    npcs TEXT DEFAULT NULL,
    knowledge TEXT DEFAULT NULL,
    conv_example_id VARCHAR(1024) DEFAULT NULL
);
GRANT SELECT ON smartnpc.scene TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.prompt_template(
    prompt_id VARCHAR(1024) NOT NULL,
    game_id VARCHAR(36) DEFAULT NULL,
    scene_id VARCHAR(1024) NOT NULL,
    prompt_template TEXT DEFAULT NULL,
    is_activate BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (scene_id, prompt_id)
);
GRANT SELECT ON smartnpc.prompt_template TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.player(
    player_id VARCHAR(1024) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    background TEXT DEFAULT NULL,
    class TEXT DEFAULT NULL,
    class_level int DEFAULT 1,
    name TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL,
    lore_level int DEFAULT 1
);
GRANT SELECT ON smartnpc.player TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.npc(
    npc_id VARCHAR(1024) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    background TEXT DEFAULT NULL,
    class TEXT DEFAULT NULL,
    class_level int DEFAULT 1,
    name TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL,
    lore_level int DEFAULT 1
);
GRANT SELECT ON smartnpc.npc TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.memory(
    memory_id VARCHAR(256) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    session_id VARCHAR(256),
    player_id VARCHAR(1024),
    npc_id VARCHAR(1024),
    summary TEXT DEFAULT NULL,
    date_time TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL,
    memory_type TEXT DEFAULT NULL,
    gametime TEXT DEFAULT NULL
);
GRANT SELECT ON smartnpc.memory TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.conversation_logs(
    conversation_id VARCHAR(256) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    session_id VARCHAR(256),
    scene_id VARCHAR(1024),
    player_id VARCHAR(1024),
    npc_id VARCHAR(1024),
    conversation_log TEXT DEFAULT NULL,
    date_time TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL,
    start_gametime TEXT DEFAULT NULL,
    end_gametime TEXT DEFAULT NULL,
    summary TEXT DEFAULT NULL
);
GRANT SELECT ON smartnpc.conversation_logs TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.conversation_examples(
    example_id VARCHAR(1024) PRIMARY KEY,
    game_id VARCHAR(36) DEFAULT NULL,
    scene_id VARCHAR(1024) DEFAULT NULL,
    conversation_example TEXT DEFAULT NULL,
    is_activate BOOLEAN DEFAULT TRUE
);
GRANT SELECT ON smartnpc.conversation_examples TO llmuser;

-- Baseball game
CREATE TABLE IF NOT EXISTS smartnpc.rosters(
    team_id VARCHAR(256) NOT NULL,
    session_id VARCHAR(256),
    player_id VARCHAR(1024) NOT NULL,
    roster TEXT DEFAULT NULL,
    PRIMARY KEY (team_id, session_id)
);
GRANT SELECT ON smartnpc.rosters TO llmuser;

CREATE TABLE IF NOT EXISTS smartnpc.lineup(
    team_id VARCHAR(256) NOT NULL,
    player_id VARCHAR(1024) NOT NULL,
    session_id VARCHAR(256),
    lineup TEXT DEFAULT NULL,
    PRIMARY KEY (team_id, player_id)
);
GRANT SELECT ON smartnpc.lineup TO llmuser;
