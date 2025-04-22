"""
Utility Functions
"""

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

import os
import asyncio
import tomllib

from google.cloud import secretmanager
from google.cloud.sql.connector import Connector
from pgvector.asyncpg import register_vector
from vertexai.language_models import TextEmbeddingInput, TextEmbeddingModel
from vertexai.preview.language_models import TextGenerationModel
from vertexai.preview import generative_models

EMBEDDING_MODEL_NAME = "text-multilingual-embedding-002"    # pylint: disable=line-too-long
TEXT_GENERATION_MODEL_NAME = "gemini-1.5-flash-001"

def get_config() -> dict:
    path = os.environ.get("DATA_INGESTION_TOML_PATH", "config.toml")

    with open(path, "rb") as f:
        config = tomllib.load(f)
        return config

def get_db_password(project_id:str, password_secret_name:str) -> str:
    """
    Get Database User password from Secret Manager

    Args:
        project_id (str): Google Cloud Project Id
        password_secret_name: Secret Name

    Returns:
        Password
    """
    client = secretmanager.SecretManagerServiceClient()

    request = secretmanager.AccessSecretVersionRequest(
        name=f"projects/{project_id}/secrets/{password_secret_name}/versions/latest"    # pylint: disable=line-too-long
    )
    response = client.access_secret_version(request)

    payload = response.payload.data.decode("UTF-8")
    return payload

def text_embedding(
  task_type: str,
  text: str,
  title: str = "",
  model_name: str = EMBEDDING_MODEL_NAME
  ) -> list:
    """
    Generate text embedding with a Large Language Model.

    Args:
        task_type (str): Task type,
        Please see:
        https://cloud.google.com/vertex-ai/generative-ai/docs/embeddings/task-types
        text (str): input text
        title (str): Optional title of the input text
        model_name (str): Defaults to text-multilingual-embedding-002
    """
    model = TextEmbeddingModel.from_pretrained(model_name)
    if task_type == "" or task_type is None:
        print("[Info]NO Emgedding Task Type")
        embeddings = model.get_embeddings([text])
    else:
        print("[Info]Using Emgedding Task Type")
        text_embedding_input = TextEmbeddingInput(
            task_type=task_type, title=title, text=text)
        embeddings = model.get_embeddings([text_embedding_input])
    return embeddings[0].values

def writeFile(path:str, content:str) -> None:
    """
    Write content to file

    Args:
        path (str): Target file path
        content (str): Content to be written
    """
    with open(path, "w+", encoding="utf-8") as f:
        f.write(f"""
{content}
""")

def invoke_gemini(prompt:str) -> str:
    """
    Invoke Gemini to generate prediction

    Args:
        prompt (str): Prompt

    Returns:
        Gemini prediction results.
    """
    model = generative_models.GenerativeModel("gemini-pro")
    parameters = {
        "max_output_tokens": 8192,
        "temperature": 0.2,
        "top_p": 0.8,
    }
    responses = model.generate_content(
        prompt,
        generation_config=parameters,
    )

    return responses.candidates[0].content.parts[0].text

def ask_llm(query:str,
            context:str,
            config:dict,
            prompt:str=None,
            stop:list[str]=None) -> str:
    """
    Invoke Large langiage model to generate prediction


    Args:
        query (str): user's input query
        context (str): Context provided to the LLM model
        config (dict): Configuration object
        prompt (str): Prompt template.
                If `None`: config["prompt"]["PROMPT_TEMPLATE"] will be used
        stop (list[str]): Stop phrase

    Returns:
        Large Language Model prediction results.
    """
    parameters = {
        "candidate_count": 1,
        "max_output_tokens": 8192,
        "temperature": 0.2,
        "top_p": 0.8,
        "top_k": 40
    }
    model = TextGenerationModel.from_pretrained(TEXT_GENERATION_MODEL_NAME)
    if prompt is None or prompt == "":
        prompt = config["prompt"]["PROMPT_TEMPLATE"]

    prompt = prompt.format(
        context,
        query
    )
    response = model.predict(
        prompt,
        **parameters,
        stop_sequences=stop
    )
    return response.text

def setup_connection(project_id:str, password_secret_name:str):
    """
    Set up database connection.

    Args:
        project_id: Google Cloud Project Id
        password_secret_name: Password secret name

    Returns:
        Password
    """
    with open("./config-secret.toml", "rb") as f:
        secrets = tomllib.load(f)
    loop = asyncio.new_event_loop()
    connector = Connector(loop=loop)
    print("Creating connection...")
    password = get_db_password(
        project_id=project_id,
        password_secret_name=password_secret_name)
    conn = loop.run_until_complete(connector.connect_async(
        secrets["gcp"]["postgres_instance_connection_name"],
        "asyncpg",
        user=secrets["gcp"]["database_user_name"],
        password=password,
        db="postgres",
    ))
    loop.run_until_complete(register_vector(conn))

    return conn, loop
