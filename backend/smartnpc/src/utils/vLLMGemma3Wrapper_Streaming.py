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
vLLM API Wrapper.
"""

import os
import json
import requests
import logging

from google.genai import types
from vertexai.generative_models import GenerationResponse


class vllm_gemma3_wrapper():
    """
    This class wrappers Gemma 3 on vLLM request and response.
    """
    def __init__(self,
                 vllm_host:str,
                 model_name:str="google/gemma-3-27b-it",
                 system_instruction:str="",
                 streaming = True
                 ):
        """
        Initialize the wrapper
        Args:
            model_name(str): Name of the model, should be "Gemini"
            system_instruction: System prompt.
            host(str): GenAI-Quickstart chat api host url.
            ex, http://api.genai.svc
        """
        self.streaming = streaming
        self.system_instruction = system_instruction
        self.model_name = model_name
        self.vllm_endpoint = f"{vllm_host}/v1/completions"
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
        print(
f"""
==== STREAMING =====
* System Instruction:
{self.system_instruction}
* Final Player Input:
{query[0]}
=====================
"""
        )
        request = {
            "stream": self.streaming,
            "model": self.model_name,
            "prompt": f"{self.system_instruction}\n{os.linesep.join(query)}",
            "max_tokens": 7384,
            "max_model_len": 9000,
            "stream_options":{"include_usage": True}
        }
        print(f">>> vLLM request:\n {json.dumps(request, indent=2)}")
        print(f"*url=self.vllm_endpoint={self.vllm_endpoint}")
        with requests.post(url=self.vllm_endpoint,
                           json=request,
                           timeout=120,
                           stream=self.streaming,
                           headers={
                                "Content-Type": "application/json"
                            }
                        ) as response:
            response.raise_for_status()
            print("Parsing response")
            for chunk in response.iter_lines(chunk_size=None):
                if chunk:
                    decoded_chunk = chunk.decode("utf-8")
                    text = ""
                    for line in decoded_chunk.splitlines():
                        if line.startswith("data: "):
                            json_data_str = line[len("data: "):].strip()
                            try:
                                data = json.loads(json_data_str)
                                if data["choices"] and data["choices"][0]["text"]:  # pylint: disable=line-too-long
                                    text = text + data["choices"][0]["text"]
                            except json.JSONDecodeError:
                                pass
                        yield types.Part.from_text(text=text)

    @property
    def models(self):
        """
        Get the models property.
        Returns:
            self: The current instance.

        """
        return self

    def generate_content_stream(
        self,
        contents
    ):
        """
        Generates content in a streaming fashion.
        Args:
            contents: The content to generate from.
        Returns:
            A generator that yields chunks of the response.

        """
        query=[os.linesep.join([p.text for p in c.parts]) for c in contents]
        return self.send_message(query=query)
