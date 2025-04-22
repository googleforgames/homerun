"""
Create SQL tables
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

import sqlalchemy
from google.cloud import secretmanager
from google.cloud.sql.connector import Connector
from utils import get_config

config = get_config()

def __get_db_password() -> str:
    """
    Get database password from Secret Manager

    Retruns:
        Password
    """
    if config["gcp"]["google-project-id"] == "":
        raise ValueError("google-project-id not set in config-secrets.toml")

    client = secretmanager.SecretManagerServiceClient()

    request = secretmanager.AccessSecretVersionRequest(
        name=f"projects/{config['gcp']['google-project-id']}/secrets/{config['gcp']['database_password_key']}/versions/latest", # pylint: disable=line-too-long, inconsistent-quotes
    )
    response = client.access_secret_version(request)

    payload = response.payload.data.decode("UTF-8")

    return payload


# initialize Connector object
connector = Connector()

# function to return the database connection object
def getconn():
    """
    Opens datanase connection

    Retruns:
        Opened connection object
    """
    conn = connector.connect(
        config["gcp"]["postgres_instance_connection_name"],
        "pg8000",
        user=config["gcp"]["database_user_name"],
        password=__get_db_password(),
        db="postgres",
    )
    return conn


pool = sqlalchemy.create_engine(
    "postgresql+pg8000://",
    creator=getconn,
)

def execute_sql(sql_file:str) -> None:
    """
    Create table

    Args:
        sql_file (str): File that contains SQL DML
    """
    with open(sql_file, "r", encoding="utf-8") as fs:
        SQL = fs.read()

    with pool.connect() as db_conn:
        print("*** Creating Extension PGVector")
        db_conn.execute(
            sqlalchemy.text("CREATE EXTENSION IF NOT EXISTS vector;")
        )
        db_conn.commit()

        print(f"*** Creating {sql_file}:")
        sql = SQL

        db_conn.execute(sqlalchemy.text(sql))
        db_conn.commit()

execute_sql("./sql/0-create_database.sql")
execute_sql("./sql/1-insert_data.sql")
