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
from models.scene import NPCSceneConversationRequest
from utils.const import LLM_BACKEND

TOML_PATH = "config.toml" if os.environ["CONFIG_TOML_PATH"] == "" else os.environ["CONFIG_TOML_PATH"] # pylint: disable=line-too-long
with open(TOML_PATH, "rb") as f:
    config = tomllib.load(f)

class ChunkParser:
    """
    ChunkParser parses chunks of text and extracts specific parts.
    The class is expecting three parts: tactics, outcomes and recommendations
    """
    def _remove_delimiters(self, input_string: str, delimiters:list[str]) -> str:
        """
        Removes predefined delimiter substrings from an input string.

        Args:
            input_string: The string to process.

        Returns:
            The string with delimiters removed.
        """

        processed_string = input_string
        for delimiter in delimiters:
            processed_string = processed_string.replace(delimiter, "===")

        return processed_string.replace("```json", "").replace("```", "===")

    def __init__(self, LLM_BACKEND:str):
        """
        Initialize the ChunkParser.
        """
        self.is_vllm = (LLM_BACKEND == "vLLM")
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
        if not self.is_vllm:
            self._full_text += chunk_text
            self._process_text()
        else:
            print(f"** _process_text_vllm: >>>{chunk_text}<<<")
            print("** _process_text_vllm:1")
            items = self._remove_delimiters(
                        chunk_text.lstrip("```json").rstrip("```"),
                        self._delimiters
                    ).split("===")
            print(f"** _process_text_vllm:2")
            ary = [item.lstrip("```json").rstrip("```") for item in items if item and not item.isspace()]
            print(f"** _process_text_vllm:3")
            self._full_text = json.dumps(ary)
            print(f"** _process_text_vllm:4")
            self._process_text_vllm()
            print(f"** _process_text_vllm:5")

    def _process_text_vllm(self):
        print(f"** _process_text_vllm:1")
        if "<tactics>" in self._full_text:
            self._full_text = self._full_text.replace("```json", "").replace("```", "")
            print(f"_process_text_vllm<tactics>:{self._full_text}")
            self._process_text()
        else:
            parts = {
                "full_content": {
                    "text": "",
                    "completed": False,
                    "sent": False
                }
            }
            temp = {}
            print(f"_process_text_vllm:self._full_text::{self._full_text}")
            ary = json.loads(self._full_text)
            for str_item in ary:
                print(f"* str_item:{str_item}")
                item = json.loads(str_item)
                if "tactics" in item:
                    temp["tactics"] = item["tactics"] # json.dumps(item["tactics"]) # json.dumps({"tactics":item["tactics"]}) # repr(json.dumps(item["tactics"]))
                if "outcomes" in item:
                    temp["outcomes"] = item["outcomes"] # json.dumps(item["outcomes"]) # # repr(json.dumps(item["outcomes"]))
                if "recommendations" in item:
                    # Ensure schema
                    if isinstance(item["recommendations"]["pitching"], str):
                        # Pitching tactic 0: Establish the 
                        index = item["recommendations"]["pitching"].split(":")[0].strip(" ")[-1]
                        pitching = {
                            "pitching":{
                                "script":item["recommendations"]["pitching"],
                                "index":int(index)
                            }
                        }
                        item["recommendations"]["pitching"] = pitching["pitching"]
                    if isinstance(item["recommendations"]["batting"], str):
                        index = item["recommendations"]["batting"].split(":")[0].strip(" ")[-1]
                        batting = {
                            "batting":{
                                "script":item["recommendations"]["batting"],
                                "index":int(index)
                            }
                        }
                        item["recommendations"]["batting"] = batting["batting"]

                    temp["recommendations"] = item["recommendations"]

            parts["full_content"]["text"] = json.dumps(temp)
            parts["full_content"]["completed"] = True
            parts["full_content"]["sent"] = False
            self.parts = parts
                # if "tactics" in item:
                #     self.parts["tactics"]["text"] = json.dumps({"tactics":item["tactics"]}) # repr(json.dumps(item["tactics"]))
                #     self.parts["tactics"]["completed"] = True
                # elif "outcomes" in item:
                #     self.parts["outcomes"]["text"] = json.dumps({"outcomes":item["outcomes"]}) # repr(json.dumps(item["outcomes"]))
                #     self.parts["outcomes"]["completed"] = True
                # elif "recommendations" in item:
                #     self.parts["recommendations"]["text"] = json.dumps({"recommendations":item["recommendations"]}) # repr(json.dumps(item["recommendations"]))
                #     self.parts["recommendations"]["completed"] = True
        print(f"** _process_text_vllm:DONE")

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
    print(f"chat_streaming...")
    if req.game_id != config["game"]["game_id"]:
        raise ValueError("Invalid game id.")
    scene = None
    if req.scene_id:
        print(
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

    # client = genai.Client(
    #   vertexai=True,
    #   project=config["gcp"]["google-project-id"],
    #   location=config["gcp"]["google-default-region"],
    # )

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

    print(f"* LLM_BACKEND={LLM_BACKEND}")
    if LLM_BACKEND == "vLLM":
        from utils.vLLMGemma3Wrapper import vllm_gemma3_wrapper
        client = vllm_gemma3_wrapper(
            vllm_host=config["game"]["vllm_host"],
            system_instruction=prompt_template
        )
        # chat = client.start_chat(history=None)
    elif LLM_BACKEND == "Gemini":
        client = genai.Client(
            vertexai=True,
            project=config["gcp"]["google-project-id"],
            location=config["gcp"]["google-default-region"],
        )
        # chat = model.start_chat(history=None)
    elif LLM_BACKEND == "Quick-Start":
        raise NotImplementedError()

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
    parser = ChunkParser(LLM_BACKEND=LLM_BACKEND)
    # ===
    if False:
        text = """```json
{
  "tactics": {
    "pitching": [
      "Establish the fastball early, Trout swings at a lot of pitches. Let's see if he'll chase something high and tight.",
      "Mix speeds, Trout is a great fastball hitter, but also can handle breaking balls. Keep him guessing by changing the tempo.",
      "Focus on the outside corner, Trout pulls the ball a lot. A few pitches out there might make him protect the plate."
    ],
    "batting": [
      "Look for a fastball. Trout's aggressive, so be ready to jump on anything early in the zone.",
      "Take a pitch or two, see what he gives you. Trout can get jumpy, and we want to exploit it.",
      "Drive the ball to right field. Trout is fast but a bit less athletic as he goes to right."
    ]
  },
  "recommendations": {
    "pitching": "Pitching tactic 0: Establish the fastball. Trout is aggressive, so let's see if he'll chase a high pitch. It's important to get ahead in the count.",
    "batting": "Batting tactic 0: Look for a fastball. Trout is aggressive, so anticipate a fastball early in the count. "
  },
  "outcomes": {
    "0.0": {
      "outcome": "Groundout to shortstop.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Groundout"
    },
    "0.1": {
      "outcome": "Strikeout swinging.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "0.2": {
      "outcome": "Single to center field.",
      "game_state": {
        "r1": true,
        "r2": false,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Single"
    },
    "1.0": {
      "outcome": "Fastball, foul ball, strike three.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "1.1": {
      "outcome": "Walk.",
      "game_state": {
        "r1": true,
        "r2": false,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Walk"
    },
    "1.2": {
      "outcome": "Line drive to right field, out.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Lineout"
    },
    "2.0": {
      "outcome": "Double to left-center field.",
      "game_state": {
        "r1": false,
        "r2": true,
        "r3": true,
        "outs": 0,
        "runs": 0
      },
      "title": "Double"
    },
    "2.1": {
      "outcome": "Foul tip, strike three.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "2.2": {
      "outcome": "Fly out to left field.",
      "game_state": {
          "r1": false,
          "r2": false,
          "r3": false,
          "outs": 1,
          "runs": 0
      },
      "title": "Flyout"
    }
  }
}
```"""
        print(f"** chunk **")
        parser.parse_chunk(text)
        print(f"parse_chunk")
        json_parts = parser.get_parts()
        print(f"get_parts:json_parts.keys()= {json_parts.keys()}")
        print(f"json_parts::{json_parts}")
        for json_part_key in json_parts.keys(): # pylint: disable=consider-using-dict-items, consider-iterating-dictionary
            print(f"json_part_key:{json_part_key}")
            if (json_parts[json_part_key]["completed"] and
                    not json_parts[json_part_key]["sent"]):
                print("sending back via ws")
                await func(
                    text=json_parts[json_part_key]["text"],
                    ws=websocket,
                    req=req)
                json_parts[json_part_key]["sent"] = True
            else:
                print(f"json_part_key:{json_part_key}: False")
        print(f"generate_content_stream:DONE")
        return
    # ===
    for chunk in client.models.generate_content_stream(
        model = model,
        contents = contents,
        config = generate_content_config,
    ):
        print(f"** chunk **")
        parser.parse_chunk(chunk.text)
        print(f"parse_chunk")
        json_parts = parser.get_parts()
        print(f"get_parts:json_parts.keys()= {json_parts.keys()}")
        print(f"json_parts::{json_parts}")
        for json_part_key in json_parts.keys(): # pylint: disable=consider-using-dict-items, consider-iterating-dictionary
            print(f"json_part_key:{json_part_key}")
            if (json_parts[json_part_key]["completed"] and
                    not json_parts[json_part_key]["sent"]):
                print("sending back via ws")
                await func(
                    text=json_parts[json_part_key]["text"],
                    ws=websocket,
                    req=req)
                json_parts[json_part_key]["sent"] = True
            else:
                print(f"json_part_key:{json_part_key}: False")
        print(f"generate_content_stream:DONE")
