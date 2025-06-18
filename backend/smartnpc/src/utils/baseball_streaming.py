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
Baseball Game Streaming Module.

This module provides a class for managing
baseball game streaming interface,
including retrieving team data, rosters,
and lineups, as well as updating lineups and
rosters.
"""

import os
import tomllib
import logging
import json

from fastapi import HTTPException, WebSocket
from google import genai
from google.genai import types
from utils.sceneManager import SceneManager
from utils.promptManager import PromptManager
from utils.vLLMGemma3Wrapper_Streaming import vllm_gemma3_wrapper
from models.scene import NPCSceneConversationRequest

TOML_PATH = "config.toml" if os.environ["CONFIG_TOML_PATH"] == "" else os.environ["CONFIG_TOML_PATH"] # pylint: disable=line-too-long
with open(TOML_PATH, "rb") as f:
    config = tomllib.load(f)

class ChunkParser:
    """
    ChunkParser parses chunks of text and extracts specific parts.
    The class is expecting three parts: tactics, outcomes and recommendations
    """
    def __init__(self):
        """
        Initialize the ChunkParser.
        """
        self.parts = {
            "tactics": {
                "completed": False,
                "sent": False,
                "text": ""  # Initialize with an empty string
            },
            "outcomes": {
                "completed": False,
                "sent": False,
                "text": ""  # Initialize with an empty string
            },
            "recommendations": {
                "completed": False,
                "sent": False,
                "text": ""  # Initialize with an empty string
            }
        }
        self._current_part = ""
        self._full_text = ""
        self._delimiters = [
            "<tactics>", "</tactics>",
            "<recommendations>", "</recommendations>",
            "<outcomes>", "</outcomes>" #consider changing this to outcomes
        ]

    def parse_chunk(self, chunk_text: str) -> None:
        """
        Parse a chunk of text and update the internal state.
        Args:
            chunk_text (str): The chunk of text to be parsed.
        """
        self._full_text += chunk_text
        self._process_text() #added processing

    def get_parts(self) -> dict:
        """
        Get the extracted parts.
        Returns:
            dict: A dictionary containing the extracted parts.
        """
        return self.parts

    def _process_text(self):
        """
        Process the full text and extract parts based
        on delimiters
        """
        for delimiter in self._delimiters:
            if delimiter in self._full_text:
                if delimiter == "<tactics>":
                    start = self._full_text.find("<tactics>") + len("<tactics>")
                    end = self._full_text.find("</tactics>")
                    if end != -1: #make sure the end tag exists
                        self.parts["tactics"]["text"] = self._full_text[start:end].strip().rstrip(  # pylint: disable=line-too-long
                            "```"
                        ).lstrip("```json")
                        self.parts["tactics"]["completed"] = True
                elif delimiter == "</tactics>":
                    pass #covered in the tactics start tag.
                elif delimiter == "<recommendations>":
                    start = self._full_text.find(
                            "<recommendations>"
                        ) + len("<recommendations>")
                    end = self._full_text.find("</recommendations>")
                    if end != -1:
                        self.parts["recommendations"]["text"] = self._full_text[start:end].strip().rstrip("```").lstrip("```json")  # pylint: disable=line-too-long
                        self.parts["recommendations"]["completed"] = True
                elif delimiter == "</recommendations>":
                    pass #covered in the recommendations start tag.
                elif delimiter == "<outcomes>":
                    start = self._full_text.find(
                            "<outcomes>"
                        ) + len("<outcomes>")
                    end = self._full_text.find("</outcomes>")
                    if end != -1:
                        self.parts["outcomes"]["text"] = self._full_text[start:end].strip().rstrip("```").lstrip("```json")  # pylint: disable=line-too-long
                        self.parts["outcomes"]["completed"] = True
                elif delimiter == "</outcomes>":
                    pass #covered in the suggestions start tag.

    def reset(self):
        """
        Reset the ChunkParser to its initial state.
        """
        self.parts = {
            "tactics": {
                "completed": False,
                "text": "",
                "sent": False
            },
            "outcomes": {
                "completed": False,
                "text": "",
                "sent": False
            },
            "recommendations": {
                "completed": False,
                "text": "",
                "sent": False
            }
        }
        self._current_part = ""
        self._full_text = ""

async def chat_streaming(req:NPCSceneConversationRequest,
                    websocket: WebSocket,
                    model:str = "gemini-2.0-flash-001",
                    temperature:float = 1,
                    top_p:float = 0.95,
                    max_output_tokens:int = 8192,
                    func:any=None) -> None:
    """Generates NPC responses

    Args:
        req: Player's input query.

    Returns:
        NPC's response to the player's inpput.
    """
    if req.game_id != config["game"]["game_id"]:
        raise ValueError("Invalid game id.")

    scene = None
    if req.scene_id:
        logging.info(
            {
                "message":f"* get_scene: {req.scene_id} | {req.game_id}" # pylint: disable=logging-fstring-interpolation
            }
        )
        scene = SceneManager(config=config).get_scene(
            game_id=req.game_id,
            scene_id=req.scene_id
        )

    if scene is None:
        raise HTTPException(status_code=400,
                            detail=f"Scene not found:{req.scene_id}")

    client = genai.Client(
      vertexai=True,
      project=config["gcp"]["google-project-id"],
      location=config["gcp"]["google-default-region"],
    )

    prompt_template = PromptManager(
                      config=config
                    ).construct_prompt(
                          prompt_id="STREAMING_GET_SUGGESTIONS",
                          scene_id=req.scene_id,#"TACTICS_SELECTION"
                        ).prompt_template
    system_prompt = types.Part.from_text(text=prompt_template)
    player_input = types.Part.from_text(text=req.input)
    logging.info("""========== system_prompt =========
%s
    """, prompt_template)
    logging.info("""========== player_input =========
%s
    """, req.input)
    model = "gemini-2.0-flash-001"
    contents = [
        types.Content(
        role="user",
        parts=[
            player_input
        ]
        ),
    ]
    generate_content_config = types.GenerateContentConfig(
        temperature = temperature,
        top_p = top_p,
        max_output_tokens = max_output_tokens,
        response_modalities = ["TEXT"],
        system_instruction=[system_prompt],
    )
    parser = ChunkParser()
    for chunk in client.models.generate_content_stream(
        model = model,
        contents = contents,
        config = generate_content_config,
    ):
        parser.parse_chunk(chunk.text)
        json_parts = parser.get_parts()
        for json_part_key in json_parts.keys(): # pylint: disable=consider-using-dict-items, consider-iterating-dictionary
            if (json_parts[json_part_key]["completed"] and
                    not json_parts[json_part_key]["sent"]):
                if json_part_key == "outcomes":
                    # Get Oneliner from vLLM
                    try:
                        outcome_json = json.loads(
                            json_parts[json_part_key]["text"]
                        )
                        outcome_array = [
                            {
                                key:outcome_json["outcomes"][key]["outcome"]
                            } for key in outcome_json["outcomes"].keys()]
                        oneliners = get_vllm_predict(
                            host=config["vllm"]["vllm_host"],
                            model_name=config["vllm"]["vllm_model_name"],
                            system_instruction="""
    # System

    You are a baseball announcer.
    You are given the lineups, 9 possible at-bat outcomes of the current at-bat and create an one-liner as an announcer.

    ## Input format

    Input is a json array of a dict, each represents an outcome of current at-bat

    ## Input Format

    ## Output format

    Respond with a json array, each corresdponding to the input at-bat outcome.
    [
        {
            "outcome index": "oneliner for this individual outcome",
            ...
        }
    ]
    For example:
    [
        {"0.0": "oneliner of the outcome 0.0"},
        {"0.1": "oneliner of the outcome 0.1"},
        {"0.2": "oneliner of the outcome 0.2"},
        {"1.0": "oneliner of the outcome 1.0"},
        {"1.1": "oneliner of the outcome 1.1"},
        {"1.2": "oneliner of the outcome 1.2"},
        {"2.0": "oneliner of the outcome 2.0"},
        {"2.1": "oneliner of the outcome 2.1"},
        {"2.2": "oneliner of the outcome 2.2"},
    ]

    """,
                            user_query=f"""{req.input}

                            ** Here is the possible outcome array:

                            {outcome_array}"""
                        )
                        if oneliners is not None:
                            for oneliner in oneliners:
                                oneliner_key = list(oneliner.keys())[0]
                                outcome_json["outcomes"][oneliner_key]["outcome"] = oneliner[oneliner_key]   # pylint: disable=line-too-long
                            json_parts[json_part_key]["text"] = json.dumps(
                                                                outcome_json
                                                            )
                    except: # pylint: disable=bare-except
                        pass
                await func(
                    text=json_parts[json_part_key]["text"],
                    ws=websocket,
                    req=req)
                json_parts[json_part_key]["sent"] = True

def get_vllm_predict(host:str,
                     model_name:str,
                     system_instruction:str,
                     user_query:str) -> str:

    vllm = vllm_gemma3_wrapper(
        vllm_host=host,
        model_name=model_name,
        system_instruction=system_instruction,
        streaming=True
    )
    contents = [
        types.Content(
            role="user",
            parts=[
                types.Part.from_text(
                    text=f"{system_instruction}{os.linesep}{user_query}"
                )
            ]
            ),
    ]
    oneliners = ""
    for resp in vllm.generate_content_stream(
        contents = contents
    ):
        oneliners = oneliners + resp.text

    oneliners = oneliners.lstrip("```json").rstrip("```")
    start_index = min(oneliners.index("["), oneliners.index("{"))
    oneliners = oneliners[start_index:]

    return json.loads(oneliners)
