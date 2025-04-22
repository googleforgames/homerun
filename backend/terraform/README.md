
# Smart NPC

The Smart NPC demonstrates using Gemini-1.5-Flash to
generate NPC dialogues while maintaining the character personality,
storyline and scene settings thorughout the conversation.

Players are expected to achieve an objective of the scene, Gemini simulate
involving NPCs to respond to the player while implicitly guiding the player
toward the objective.

## Baseball simulation demo game

This example using the concept of LLM powered Smart NPC
in a baseball simulation game,
where the player plays the coach of a baseball team.
The `NPC` which powered by the LLM
provides tactics suggestions to the player.

## Applicaiton Flow

[Smart NPC API flow](./docs/0-SmartNPC-API-Flow.md)

[Game flow](./docs/1-Game-Flow.md)

## Prerequisites

-   [Terraform](https://www.terraform.io/downloads.html)
-   [gcloud](https://cloud.google.com/sdk/docs/install)
-   [kubectl](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_kubectl)
-   [Skaffold](https://skaffold.dev/docs/)
-   [Helm](https://helm.sh/docs/intro/install/)

## Getting started

The following steps below will walk you through the setup guide for *GenAI Quickstart*.
The process will walk through enabling the proper **Google Cloud APIs**,
creating the resources via **Terraform**, and deployment of the **Kubernetes manifests**
needed to run the project.

> **Note:** These steps assume you already have a running project in
Google Cloud for which you have IAM permissions to deploy resources into.

### 1) Clone this git repository

```shell
git clone https://github.com/googleforgames/homerun.git

cd homerun/backend
```

### 2) Set ENV variable

Set your unique Project ID for Google Cloud

```shell
# To just use your current project
export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)

# Otherwise set it to the project you wish to use.
# Set default location for Google Cloud
export LOCATION=us-central1
```

To better follow along with this quickstart guide, set `CUR_DIR` env variable

```shell
export CUR_DIR=$(pwd)
```

### 3) Confirm user authentication to Google Cloud project

```shell
gcloud auth list
```

Check if your authentication is ok and your `PROJECT_ID` is valid.

```shell
gcloud projects describe ${PROJECT_ID:?}
```

You should see the your `PROJECT_ID` listed with an `ACTIVE` state.

### 4) Enable Google Cloud APIs

```shell
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
  redis.googleapis.com
```

### Update Organization Policies as needed

Update the following Organization Policies to loosen restrictions.

-   `compute.vmExternalIpAccess`
-   `sql.restrictAuthorizedNetworks`
-   `compute.requireShieldedVm`

### 5) Deploy infrastructure with Terraform

```shell
cd ${CUR_DIR:?}/terraform

cat terraform.example.tfvars | \
sed -e "s:your-unique-project-id:${PROJECT_ID:?}:g" > terraform.tfvars

terraform init

terraform plan

terraform apply
```

The deployment of cloud resources can take between 5 - 10 minutes.

### 6) Setup GKE credentials

After cloud resources have successfully been deployed with Terraform,
get newly created GKE cluster credentials.

```shell
gcloud container clusters get-credentials smartnpc --region us-central1 \
--project ${PROJECT_ID:?}
```

Test your Kubernetes client credentials.

```shell
kubectl get nodes
```

### Create Database and Tables

```shell
cd ../smartnpc/data
python3 -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt

python3 ./setup-database.py
```

### 7) Deploy GenAI workloads on GKE

Switch to the `smartnpc` directory, Terraform automatically create `cloudbuild.yaml`,
verify if the configuration in the `cloudbuild.yaml` file is correct.

```shell
cd ${CUR_DIR:?}/smartnpc
gcloud builds submit --config=cloudbuild.yaml
```

Deploy the Smart NPC backend

```shell
gcloud container clusters get-credentials smartnpc --region ${LOCATION} \
--project ${PROJECT_ID}

kubectl create ns genai

kubectl create configmap -n genai \
  smart-npc-config --from-file=../smartnpc/config.toml

kubectl apply -f ../smartnpc/k8s.yaml

```

### 8) Get Backend Endpoint and API Key

Wait until Load balancer gets created, you can check the status by
running the following command.

```shell
kubectl get svc -n genai

# NAME                TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
# smart-npc-ssl-svc   LoadBalancer   1.2.3.4          x.x.x.x     80:30381/TCP   2m13s
```

Access the API - You can test the application and all the APIs from here  :)

To get the public ip address, WebSocket Uri and API Key of the service, run

```shell
export SMARTNPC_HTTP_URL=http://$(kubectl get svc -n genai --output json \
-o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')

export SMARTNPC_WS_URI=ws://$(kubectl get svc -n genai --output json \
-o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')/game/streaming

echo "====== Update the following values to Game.js ====="

echo APIURL=$SMARTNPC_HTTP_URL
echo WSURL=$SMARTNPC_WS_URI
cat ${CUR_DIR:?}/smartnpc/config.toml | grep api-key
```

then in another window run:

```shell
curl $SMARTNPC_HTTP_URL
```

You should see:

```text
"{\"message\": \"ok\"}"
```

## Project cleanup

### Remove Kubernetes resources

In `genai` directory

```shell
cd ${CUR_DIR:?}/smartnpc

kubectl delete -f k8s.yaml
```

### Remove infrastructure

In `terraform` directory

```shell
cd ${CUR_DIR:?}/terraform

terraform destroy
```

## Troubleshooting

### Not authenticated with Google Cloud project

If you are not running the above project in Google Cloud shell,
make sure you are logged in and authenticated with your desired project:

```shell
gcloud auth application-default login

gcloud config set project ${PROJECT_ID:?}
```

and follow the authentication flow.

### Identity Pool does not exist

If you see this error, wait for 5 minutes till the Identity pool is created.

---

## Contributing

The entire repo can be cloned and used as-is, or in many cases you may
choose to fork this repo and keep the code base that is most useful
and relevant for your use case.
If you'd like to contribute, then more info can be found witin our
[contributing guide](./CONTRIBUTING.md).
