# Home Run OSS Repository 

This is the repository for the open source portions of the Google Cloud GenAI game demo "Home Run: Gemini Coach Edition" HTML frontend.  The client is a javascript Pixi.js project, and in order to run it locally, you will need `npm` installed, then follow these steps:

## Before you begin

### Gemma on GKE Setup

This demo uses Gemma 3 on GKE to generate game content, before deploy the solution please follow [this instruction](<TODO: Add links>)
to setup Gemma 3 model on GKE.

Once you setup the Gemma 3 on GKE, please update [config.toml](./backend/smartnpc/config.app.toml.template) with the vLLM endpoint and Gemma 3 model name.

```toml
[vllm]
vllm_model_name="<Gemma 3 model name, for example: google/gemma-3-27b-it>"
vllm_host = "<vLLM host, for example: http://vllm.somedomain:port>"

[game]
game_id = "baseball"
enable_validator = "False"
# ...other configuraions...
```

### SmartNPC Backend Setup
* Clone this repository and follow the [instructions](./backend/terraform/README.md) to setup the game backend.
and note the following outputs provided by the backend setup:

  -   `APIURL`, and `WSURL` will be provided to you in the console output.
  -   `APIKEY` is generated and stored in `config.toml` in the `SmartNPC` example folder.

* Update `APIKEY`, `APIURL`, and `WSURL` variables at the top of the [Game.js](./frontend/src/Game.js) file with the values you got from standing up the backend.  If you haven't populated these values, you will receive a `Uncaught Error: Unable to start without API key and backend endpoints` error in your browser developer tools console.

* Details of the game backend architecture, including Gemini integration, please refer to the following documents.

  -   [Backend overview](./backend/smartnpc/README.md)
  -   [Deployment steps](./backend/terraform/README.md)

## Setup the frontend

* set up the dependencies using NPM:

  ```
  cd frontend

  npm install
  npm run dev
  ```

* Use your browser of choice to connect to the client at the address provided by `npm run dev` (typically [http://localhost:8080/]()).

You can view the logs from the client using your browser's developer tools.

## Additional Information
This project is intended for demonstration purposes only. It is not
intended for use in a production environment.

This is not an officially supported Google product. This project is not
eligible for the [Google Open Source Software Vulnerability Rewards
Program](https://bughunters.google.com/open-source-security).
