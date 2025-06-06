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
GenAI-Quickstart Chat API Wrapper.
"""

import os
import json
import requests
import logging
import datetime

from google.genai import types
from vertexai.generative_models import GenerationResponse

STREAMING = True

class vllm_gemma3_wrapper():
    """
    This class wrappers Gemma 3 on vLLM request and response.
    """
    def __init__(self,
                 vllm_host:str,
                 model_name:str="google/gemma-3-12b-it",
                 system_instruction:str=""):
        """
        Initialize the wrapper
        Args:
            model_name(str): Name of the model, should be "Gemini"
            system_instruction: System prompt.
            host(str): GenAI-Quickstart chat api host url.
            ex, http://api.genai.svc
        """
        self.system_instruction = system_instruction
        self.model_name = model_name
        # self.host = f"{vllm_host}/v1/chat/completions"
        self.host = f"{vllm_host}/v1/completions"
        self.history = []
        self.logger = logging.getLogger("smart-npc")
        self.logger.setLevel(logging.DEBUG)

    def start_chat(self, history:list[dict]) -> any:
        """
        Start a chat.
        Args:
            history(list[dict]): conversation history
        Retuns:
            Response from the LLM
        """
        self.history = history if history is not None else []
        return self

    def send_message(self,
                     query:list[str],
                     generation_config:dict=None, # pylint: disable=unused-argument
                     safety_settings:dict=None) -> GenerationResponse: # pylint: disable=unused-argument
        """
        Send message to the chat model.
        Args:
            query(str): User's input
            generation_config(dict): generation config. Reserved for compability
            safety_settings(dict): safety settings. Reserved for compability
        Retuns:
            LLM response.
        """
        self.logger.info(
"""
==== STREAMING =====
* System Instruction:
%s
* Final Player Input:
%s
=====================
""",
self.system_instruction,
query[0]
        )
        start = None
        end = None
        request = {
            "stream": STREAMING,
            "model": self.model_name,
            "prompt": f"{self.system_instruction}\n{os.linesep.join(query)}",
            "max_tokens": 7384,
            "max_model_len": 9000
        }
        start = datetime.datetime.now()
        with requests.post(url=self.host, json=request, timeout=120, stream=STREAMING, headers={
                                        "Content-Type": "application/json"
                                    }
                                ) as response:
            response.raise_for_status()
            print("Parsing response")
            for chunk in response.iter_lines(chunk_size=None):
                if chunk:
                    decoded_chunk = chunk.decode('utf-8')
                    print(f"** [{datetime.datetime.now()}]STREAMING:chukn:{chunk}")
                    end = datetime.datetime.now()
                    print(f"** took: {(end - start).seconds} seconds.")
                    # yield chunk
                    text = ""
                    for line in decoded_chunk.splitlines():
                        if line.startswith("data: "):
                            json_data_str = line[len("data: "):].strip()
                            try:
                                data = json.loads(json_data_str)
                                print(json.dumps(data, indent=2))
                                if data["choices"] and data["choices"][0]["text"]:
                                    text = text + data["choices"][0]["text"]
                            except json.JSONDecodeError:
                                pass
                        yield types.Part.from_text(text=text)

    @property
    def models(self):
        return self

    def generate_content_stream(
        self,
        contents,
        model:str="google/gemma-3-12b-it",
        config:types.GenerateContentConfig=None,
    ):
        query=[os.linesep.join([p.text for p in c.parts]) for c in contents]
        self.logger.info(
            """generate_content_stream:query=\n%s""",
            os.linesep.join(query)
        )
        return self.send_message(query=query)