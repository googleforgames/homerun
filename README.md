# Home Run OSS Repository 

This is the repository for the open source portions of the
Google Cloud GenAI game demo "Home Run: Gemini Coach Edition" HTML frontend.
The client is a javascript Pixi.js project, and in order to run it locally,
you will need `npm` installed, then follow these steps:

## Before you begin

Enable required services.

```shell
export PROJECT_ID=<your-project-id>

gcloud services enable --project ${PROJECT_ID:?} \
  aiplatform.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  cloudresourcemanager.googleapis.com \
  compute.googleapis.com \
  container.googleapis.com \
  containerfilesystem.googleapis.com \
  containerregistry.googleapis.com \
  iam.googleapis.com \
  servicecontrol.googleapis.com \
  spanner.googleapis.com \
  secretmanager.googleapis.com \
  redis.googleapis.com \
  vpcaccess.googleapis.com
```

The solution offers two deployment strategies:

1. **Deploy with Gemma 3 model on GKE** Deploy Gemma 3 model on GKE
and deploy the demo application on same cluster.

2. **Standalone** Do not use Gemma 3 on GKE,
and deploy a GKE cluster dedicated for the demo.

## Gemma 3 on GKE Setup

If you choose to setup **Deploy with Gemma 3 model on GKE** approach,
follow the [instructions](https://github.com/GoogleCloudPlatform/accelerated-platforms/tree/int-online-tpu/platforms/gke/base/use-cases/inference-ref-arch/examples/online-inference-tpu) here
to deploy Gemma 3 model on GKE.

If you choose to setup **Standalone** approach, skip to next section.

Once you setup the Gemma 3 on GKE, please update
[config.toml](./backend/smartnpc/config.app.toml.template)
with the vLLM endpoint and Gemma 3 model name.

```toml
[vllm]
vllm_model_name="<Gemma 3 model name, for example: google/gemma-3-27b-it>"
vllm_host = "<vLLM host, for example: http://vllm.somedomain:port>"

[game]
game_id = "baseball"
enable_validator = "False"
# ...other configuraions...
```

## Setup SmartNPC Backend

### Deploy with Gemma 3 model on GKE

This section describe deployment steps for Gemma 3 model on GKE.

* Clone this repository and follow the
[instructions](./backend/terraform-gemma3/README.md)
to setup the game backend.
and note the following outputs provided by the backend setup:

  -   `APIURL`, and `WSURL` will be provided to you in the console output.
  -   `APIKEY` is generated and stored in `config.toml` in the `SmartNPC`
  example folder.

* Update `APIKEY`, `APIURL`, and `WSURL` variables at the top of the
[Game.js](./frontend/src/Game.js) file with the values you got
from standing up the backend.
If you haven't populated these values, you will receive a
`Uncaught Error: Unable to start without API key and backend endpoints`
error in your browser developer tools console.

* Details of the game backend architecture, including Gemini integration,
please refer to the following documents.

  -   [Backend overview](./backend/smartnpc/README.md)
  -   [Deployment steps](./backend/terraform/README.md)


### Standalone

This section describe deployment steps for Standalone deployment.

* Clone this repository and follow the
[instructions](./backend/terraform-gemma3/README.md)
to setup the game backend.
and note the following outputs provided by the backend setup:

  -   `APIURL`, and `WSURL` will be provided to you in the console output.
  -   `APIKEY` is generated and stored in `config.toml` in the `SmartNPC`
  example folder.

* Update `APIKEY`, `APIURL`, and `WSURL` variables at the top of the
[Game.js](./frontend/src/Game.js) file with the values you got
from standing up the backend.
If you haven't populated these values, you will receive a
`Uncaught Error: Unable to start without API key and backend endpoints`
error in your browser developer tools console.

* Details of the game backend architecture, including Gemini integration,
please refer to the following documents.

  -   [Backend overview](./backend/smartnpc/README.md)
  -   [Deployment steps](./backend/terraform/README.md)


## Setup the frontend

* set up the dependencies using NPM:

  ```
  cd frontend

  npm install
  npm run dev
  ```

* Use your browser of choice to connect to the client
at the address provided by `npm run dev` (typically `http://localhost:8080/`).

You can view the logs from the client using your browser's developer tools.

## Additional Information
This project is intended for demonstration purposes only. It is not
intended for use in a production environment.

This is not an officially supported Google product. This project is not
eligible for the [Google Open Source Software Vulnerability Rewards
Program](https://bughunters.google.com/open-source-security).
