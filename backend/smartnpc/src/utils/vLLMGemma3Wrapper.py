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

from google.genai import types
from vertexai.generative_models import GenerationResponse

class vllm_gemma3_wrapper():
    """
    This class wrappers Gemma 3 on vLLM request and response.
    """
    def __init__(self,
                 vllm_host:str,
                 model_name:str="google/gemma-3-4b-it",
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
        self.host = f"{vllm_host}/v1/chat/completions"
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
=====================
* System Instruction:
%s
* Final Player Input:
%s
=====================
""",
self.system_instruction,
query[0]
        )

        request = {
            "model": "google/gemma-3-4b-it",
            "messages": [
                {
                    "role": "system",
                    "content": self.system_instruction
                },
                {
                "role": "user",
                "content": os.linesep.join(query)
                }
            ]
        }
        try:
            print("sending to vLLM")
            response = requests.post(url=self.host, json=request, timeout=120, headers={
                                        "Content-Type": "application/json"
                                    }
                                )
            print("sending to vLLM. Done")
        except Exception as e:
            self.logger.error("* Request:%s", json.dumps(request))
            self.logger.error("* Exception:%s", f"{e}")
            raise e

        self.logger.info("""******
vllm_gemma3_wrapper::Response.Text:
%s
******
""",
response.text)
        print(("""******
vllm_gemma3_wrapper::Response.Text:
%s
******
""",
response.text))
        if self.history is None:
            self.history = []
        if response.status_code == 200:
            print("Parsing response")
            returned_text = json.loads(
                                        response.text.lstrip("```json").rstrip("```") # pylint: disable=line-too-long
                                    )["choices"][0]["message"]["content"]
            answer = {
                "candidates": [
                    {
                        "content":{
                            "parts":[
                                {
                                    "text":returned_text
                                }
                            ]
                        }
                    }
                ]
            }
            resp = GenerationResponse.from_dict(answer)
            print(f"returned GenerationResponse.from_dict")
            return [resp]
        else:
            print("error send_message:response.status_code=%s",)
            self.logger.error(
                "error send_message:response.status_code=%s",
                response.status_code
            )
            return None

    @property
    def models(self):
        return self

    """
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
    """
    def generate_content_stream(
        self,
        contents,
        model:str="google/gemma-3-4b-it",
        config:types.GenerateContentConfig=None,
    ):
        query=[os.linesep.join([p.text for p in c.parts]) for c in contents]
        self.logger.info(
            """generate_content_stream:query=\n%s""",
            os.linesep.join(query)
        )
        return self.send_message(query=query)