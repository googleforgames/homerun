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


locals {
  k8s_yaml_content = <<-EOT
# Copyright 2025 Google LLC All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# # If you want to use HTTPS, uncomment the following
# # to create a Google managed certificate
# # You MUST specify the domain name you want to use
# ---
# apiVersion: networking.gke.io/v1
# kind: ManagedCertificate
# metadata:
#   name: gdc-demo-cert
# spec:
#   domains:
#     - <YOUR DOMAIN NAME, ex:abc.com>
# ---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: sa-gke-aiplatform@${var.google_project_id}.iam.gserviceaccount.com
  name: k8s-sa-aiplatform
  namespace: genai
---
apiVersion: v1
kind: Namespace
metadata:
  name: genai
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: genai
  name: smart-npc-api
  labels:
    name: smart-npc-api
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 40%
      maxUnavailable: 0
  selector:
    matchLabels:
      name: smart-npc-api
  template:
    metadata:
      labels:
        name: smart-npc-api
        version: stable
      # annotations:
        # instrumentation.opentelemetry.io/inject-python: "genai-instrumentation"
    spec:
      serviceAccountName: k8s-sa-aiplatform
      restartPolicy: Always
      containers:
      - image: ${var.google_default_region}-docker.pkg.dev/${var.google_project_id}/repo-genai-smartnpc/smart-npc-api
        name: smart-npc-api
        imagePullPolicy: Always
        ports:
        - name: http
          containerPort: 8080
          protocol: TCP
        readinessProbe:
          httpGet:
            path: /docs
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 30
        env:
        - name: ENV
          value: dev
        - name: CONFIG_TOML_PATH
          value: /config/config.toml
        resources:
          requests:
            cpu: 500m
            memory: 256Mi
          limits:
            memory: 512Mi
        volumeMounts:
        - name: config-volume
          mountPath: /config/config.toml
          subPath: "config.toml"
      volumes:
      - name: config-volume
        configMap:
          name: smart-npc-config
---
apiVersion: v1
kind: Service
metadata:
  name: smart-npc-ssl-svc # Name of Service
  namespace: genai
  annotations:
    cloud.google.com/backend-config: '{"default": "smart-npc-websocket-timeout"}'
    cloud.google.com/neg: '{"ingress": true}' # Creates a NEG after an Ingress is created
spec:
  type: LoadBalancer # Change to NodePort if you want to use Ingress with HTTPS
  selector:
    name: smart-npc-api
  ports:
  - name: http
    port: 80 # Service's port
    protocol: TCP
    targetPort: 8080
---
# # Uncomment if you want to use Ingress with HTTPS
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: smart-npc-https-ingress
#   namespace: genai
#   annotations:
#     # kubernetes.io/ingress.global-static-ip-name: "smart-npc-https-ip"
#     # networking.gke.io/managed-certificates: "smart-npc-api-ssl-cert"
#     kubernetes.io/ingress.global-static-ip-name: "gdc-demo-baseball-ip"
#     networking.gke.io/managed-certificates: "gdc-demo-cert"
# spec:
#   defaultBackend:
#     service:
#       name: smart-npc-ssl-svc # Name of the Service targeted by the Ingress
#       port:
#         number: 60000 # Should match the port used by the Service
# ---
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: smart-npc-websocket-timeout
  namespace: genai
spec:
  timeoutSec: 6000

    EOT
}

resource "local_file" "k8s-yaml" {
  filename = "../smartnpc/k8s.yaml"
  content  = local.k8s_yaml_content
}
