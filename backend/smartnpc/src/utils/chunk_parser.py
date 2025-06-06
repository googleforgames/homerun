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
        self._full_text += chunk_text
        self._process_text()

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

    def get_parts(self) -> dict:
        """
        Get the extracted parts.
        Returns:
            dict: A dictionary containing the extracted parts.
        """
        return self.parts

    def _ensure_recommendations_schema(self) -> str:
        print(f"""* self.parts["recommendations"]["text"]={self.parts["recommendations"]["text"]}""")
        logging.info (f"""* self.parts["recommendations"]["text"]={self.parts["recommendations"]["text"]}""")
        recommendation = json.loads(self.parts["recommendations"]["text"])
        result = {}
        if isinstance(recommendation["pitching"], str):
            # Pitching tactic 0: Establish the 
            index = recommendation["pitching"].split(":")[0].strip(" ")[-1]
            pitching = {
                "pitching":{
                    "script":recommendation["pitching"],
                    "index":int(index)
                }
            }
            result["pitching"] = pitching["pitching"]
        if isinstance(recommendation["batting"], str):
            index = recommendation["batting"].split(":")[0].strip(" ")[-1]
            batting = {
                "batting":{
                    "script":recommendation["batting"],
                    "index":int(index)
                }
            }
            result["batting"] = batting["batting"]
        self.parts["recommendations"]["text"] = json.dumps(result)


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

