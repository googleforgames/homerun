# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""
Baseball Game Logic Module.

This module provides a class for managing baseball game logic, including
retrieving team data, rosters, and lineups, as well as updating lineups and
rosters.
"""

import json
import os

from typing import Optional
from utils.cacheWrapper import CacheFactory
from utils.database import DataConnection

def format_current_state(state:str) -> str:
    """
    Get formatted current state string.
    Args:
        state(str): Current state.
    Returns:
        Formatted current state,
        which will become part of user input to the LLM.
    """
    stateObj = json.loads(state)

    formatted_state = f"""
## Current State
{stateObj["CURRENT_STATE"]}
"""
    return formatted_state

def format_lineup(lineup:dict) -> str:
    """
    Format the lineup json to markdown table.
    Args:
        lineup(dict): lineup
    Returns:
        Markdown table.
    """
    markdown = format_pitcher_lineup(
            lineup=lineup
        ) + format_batters_lineup(
            lineup=lineup
        )

    return markdown

def format_pitcher_lineup(lineup:dict) -> str:
    """
    Format the lineup json to markdown table.
    Args:
        lineup(dict): lineup
    Returns:
        Markdown table.
    """
    pitcher = lineup["lineup"]["pitcher"]
    markdown = ""

    markdown = markdown + f"""
* Pitcher: { pitcher["name"]}

"""
    pitcher_header = "||" + "|".join(
        [key for key in pitcher["stats"]["this_season"].keys()]
    ) + "|"
    pitcher_header = pitcher_header + """
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
"""
    pitch_stastics = "|This Season|" + "|".join(
        [f"""{pitcher["stats"]["this_season"][key]}""" for
            key in pitcher["stats"]["this_season"].keys()]
    ) + "|" + os.linesep
    pitch_stastics = pitch_stastics + "|Career|" + "|".join(
        [f"""{pitcher["stats"]["career"][key]}""" for
            key in pitcher["stats"]["this_season"].keys()]
    ) + "|"  + os.linesep
    markdown = markdown + pitcher_header + pitch_stastics

    return markdown

def format_batters_lineup(lineup:dict) -> str:
    """
    Format the lineup json to markdown table.
    Args:
        lineup(dict): lineup
    Returns:
        Markdown table.
    """
    batters = lineup["lineup"]["fielders"]
    markdown = "* Lineup" + os.linesep+ os.linesep

    columns = "|Position|Name|Hand|Avg|HR|RBI|Notes|" + os.linesep
    columns = columns + "|:--:|:--:|:--:|:--:|:--:|:--:|:--:|" + os.linesep
    statistics_table = ""
    batter_statistics = ""
    for batter in batters:
        if isinstance(batter, dict):
            batter_statistics = "|" + \
                batter["position"] + \
                "|" + \
                batter["name"] + \
                "|" + \
                batter["hand"] + \
                "|" + \
                f"""{batter["avg"]}""" + \
                "|" + \
                f"""{batter["hr"]}""" + \
                "|" + \
                f"""{batter["rbi"]}""" + \
                "|" + \
                batter["notes"] + \
                "|" + \
                os.linesep
        elif isinstance(batter, list):
            batter_statistics = "|" + \
                batter[0] + \
                "|" + \
                batter[1] + \
                "|" + \
                batter[2] + \
                "|" + \
                f"""{batter[3]}""" + \
                "|" + \
                f"""{batter[4]}""" + \
                "|" + \
                f"""{batter[5]}""" + \
                "|" + \
                batter[6] + \
                "|" + \
                os.linesep

        statistics_table = statistics_table + batter_statistics
    markdown = markdown + columns + statistics_table

    return markdown

class BaseballGameHelper():
    """
    Helper class for prompt management.
    """
    def __init__(self, config:dict):
        """
        Initialize the prompt manager helper class.

        Args:
            config (dict): config.toml dict.
        """
        self._cache = CacheFactory(config=config).get_cache("game")
        self._config = config
        self._connection = DataConnection(config=config)

    def __format_game_data_cache_key(
        self,
        game_id:str,
        session_id:str,
        team_id:str) -> str:
        """
        Format conversation cache key

        Args:
            game_id (str): game id.
            session_id (str): session id.
            team_id (str): team id.
        Returns:
            Formatted cache key.
        """
        return f"{game_id}/{session_id}/{team_id}"

    def __format_roster_data_cache_key(
        self,
        game_id:str,
        session_id:str,
        team_id:str) -> str:
        """
        Format conversation cache key
        Args:
            game_id (str): game id.
            session_id (str): session id.
            team_id (str): team id.
        Returns:
            Formatted cache key.
        """
        return f"{game_id}/{session_id}/{team_id}/roster"

    def __format_lineup_data_cache_key(
        self,
        game_id:str,
        session_id:str,
        team_id:str) -> str:
        """
        Format conversation cache key
        Args:
            game_id (str): game id.
            session_id (str): session id.
            team_id (str): team id.
        Returns:
            Formatted cache key.
        """
        return f"{game_id}/{session_id}/{team_id}/lineup"

    def get_teams(
            self
        ) -> list[dict]:
        """
        Get Team data.

        Args:
            team_id (str): team id.
                    if none team id is given, returns all teams.

        Returns:
            Team Data.
        """
        team_id = "all"
        sql = self._config["baseball"]["QUERY_TEAMS"]
        sql_params = None
        session_id="all"

        game_id = self._config["game"]["game_id"]
        key = self.__format_game_data_cache_key(
                                    game_id=game_id,
                                    session_id=session_id,
                                    team_id=team_id)
        all_teams = self._cache.get(key=key)

        if all_teams is None or all_teams == "":
            results = self._connection.execute(
                sql = sql,
                sql_params=sql_params
            )
            all_teams = []
            for result in results:
                t = {
                        "team_id": result[0],
                        "team_name": f"{result[2]} {result[1]}",
                        "team_year": result[2],
                        "description": result[3],
                        "roster": json.loads(result[4]),
                        "default_lineup": json.loads(result[5])
                    }
                key = self.__format_game_data_cache_key(
                    game_id=game_id, session_id=session_id, team_id=t["team_id"]
                )
                all_teams.append(t)
                self._cache.set(key, t)

            key = self.__format_game_data_cache_key(
                game_id=game_id, session_id=session_id, team_id="all"
            )
            self._cache.set(key, all_teams)

        return all_teams

    def get_team(
            self,
            team_id:str
        ) -> list[dict]:
        """
        Get Team data.

        Args:
            team_id (str): team id.
                    if none team id is given, returns all teams.

        Returns:
            Team Data.
        """
        if team_id == "" or team_id is None:
            raise ValueError("team_id must not be empty.")
        else:
            sql = self._config["baseball"]["QUERY_TEAM"]
            sql_params={
                    "team_id":team_id
                }

        session_id="all"

        game_id = self._config["game"]["game_id"]
        key = self.__format_game_data_cache_key(
                                    game_id=game_id,
                                    session_id=session_id,
                                    team_id=team_id)
        team = self._cache.get(key=key)
        teams = []
        if team is None or team == "":
            results = self._connection.execute(
                sql = sql,
                sql_params=sql_params
            )
            for result in results:
                team = {
                        "team_id": result[0],
                        "team_name": f"{result[2]} {result[1]}",
                        "team_year": result[2],
                        "description": result[3],
                        "roster": json.loads(result[4]),
                        "default_lineup": json.loads(result[5])
                    }
                key = self.__format_game_data_cache_key(
                    game_id=game_id,
                    session_id=session_id,
                    team_id=team["team_id"]
                )
                teams.append(team)
                self._cache.set(key, team)
        else:
            teams.append(team)
        return teams

    def get_roster(self, team_id:str,
                   session_id:str,
                   player_id:str
                ) -> Optional[dict]:
        """
        Get team roster.

        Args:
            team_id(str): team id.
            session_id(str): session id.
            player_id(str): player id.

        Returns:
            Team data.
        """
        if team_id == "" or team_id is None:
            raise ValueError("team_id must not be empty.")
        else:
            sql = self._config["baseball"]["QUERY_TEAM_ROSTER"]
            sql_params={
                    "team_id":team_id,
                    "session_id":session_id,
                    "player_id":player_id
                }

        game_id = self._config["game"]["game_id"]
        key = self.__format_roster_data_cache_key(
                                    game_id=game_id,
                                    session_id=session_id,
                                    team_id=team_id)
        roster = self._cache.get(key=key)
        team = None
        if roster is None or roster == "":
            results = self._connection.execute(
                sql = sql,
                sql_params=sql_params
            )
            for result in results:
                team = {
                        "team_id": team_id,
                        "session_id": session_id,
                        "player_id": player_id,
                        "roster": json.loads(result[3])
                    }
                key = self.__format_roster_data_cache_key(
                    game_id=game_id,
                    session_id=session_id,
                    team_id=team_id
                )
                self._cache.set(key, team)
        else:
            team = {
                        "team_id": team_id,
                        "session_id": session_id,
                        "player_id": player_id,
                        "roster": roster
                    }
        return team

    def get_lineup(self,
                   team_id:str,
                   session_id:str,
                   player_id:str
                ) -> Optional[dict]:
        """
        Get team lineup.

        Args:
            team_id(str): team id.
            session_id(str): session id.
            player_id(str): player id.

        Returns:
            Team lineup.
        """
        if team_id == "" or team_id is None:
            raise ValueError("team_id must not be empty.")
        else:
            sql = self._config["baseball"]["QUERY_TEAM_LINEUP"]
            sql_params={
                    "team_id":team_id,
                    "session_id":session_id,
                    "player_id":player_id
                }

        game_id = self._config["game"]["game_id"]
        key = self.__format_lineup_data_cache_key(
                                    game_id=game_id,
                                    session_id=session_id,
                                    team_id=team_id)
        lineup = self._cache.get(key=key)
        team = None
        if lineup is None or lineup == "":
            results = self._connection.execute(
                sql = sql,
                sql_params=sql_params
            )
            for result in results:
                team = {
                        "team_id": team_id,
                        "session_id": session_id,
                        "player_id": player_id,
                        "lineup": json.loads(result[3])
                    }
                self._cache.set(key, team)
        else:
            team = {
                    "team_id": team_id,
                    "session_id": session_id,
                    "player_id": player_id,
                    "lineup": lineup["lineup"] if "lineup" in lineup else lineup # pylint: disable=line-too-long
                }
        return team

    def update_lineup(self,
                      team_id:str,
                      session_id:str,
                      player_id:str,
                      lineup:dict
                    ) -> None:
        """
        Update or Insert team lineup.

        Args:
            team_id(str): team id.
            session_id(str): session id.
            player_id(str): player id.

        Returns
            Team lineup
        """
        print(f"Updating lineup...{type(lineup)} | {lineup}")
        sql = self._config["baseball"]["UPSERT_TEAM_LINEUP"]
        sql_params = {
            "team_id": team_id,
            "session_id": session_id,
            "player_id": player_id,
            "lineup": json.dumps(lineup)
        }
        self._connection.execute(sql=sql, sql_params=sql_params)
        key = self.__format_lineup_data_cache_key(
            game_id = self._config["game"]["game_id"],
            session_id=session_id,
            team_id=team_id
        )
        self._cache.set(key, lineup)

    def update_roster(self,
                      team_id:str,
                      session_id:str,
                      player_id:str,
                      roster:dict
                    ) -> None:
        """
        Update or Insert team roster.

        Args:
            team_id(str): team id.
            session_id(str): session id.
            player_id(str): player id.

        Returns
            Team roster
        """
        sql = self._config["baseball"]["UPSERT_TEAM_ROSTER"]
        sql_params = {
            "team_id": team_id,
            "session_id": session_id,
            "player_id": player_id,
            "roster": json.dumps(roster)
        }
        self._connection.execute(sql=sql, sql_params=sql_params)
        key = self.__format_roster_data_cache_key(
            game_id = self._config["game"]["game_id"],
            session_id=session_id,
            team_id=team_id
        )
        self._cache.set(key, roster)
