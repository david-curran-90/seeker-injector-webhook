# Seeker Injector

Go based webhook to inject the seeker agent into existing NodeJS applications

## Overview

View write up on [Confluence](https://confluence.telstrahealth.com/display/DFIA/Running+Seeker+with+Kubernetes+applications). This project will inject an [init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) into a running application with the right annotation and copy the agent into a volume shared with other pod containers. The application can then make use of seeker by modifying the command it runs.

## Usage

To enable the webhook the Namespace requires a label and the pod an annotation `seeker.drfoster.co/inject: enabled`. Seeker supports multiple languages but each must run in a different way, we are supported NodeJS and DotNetCore currently as these are the main languages our apps are written in. Other languages can be supported in the future. View the below code block for a full example of a NodeJS deployment using Seeker.

```
apiVersion: v1
kind: Namespace
metadata:
  labels:
    seeker.drfoster.co/inject: enabled
  name: seeker-testing
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-inject
  labels:
    app: nodejs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nodejs
  template:
    metadata:
      annotations:
        seeker.drfoster.co/inject: enabled
        seeker.drfoster.co/tech: nodejs
      labels:
        app: nodejs
    spec:
      imagePullSecrets:
        - name: drfostercontainerreg
      containers:
      - name: nginx
        image: drfostercontainerreg.azurecr.io/my-node-app:1.0.0
        ports:
        - containerPort: 3000
        env:
        - name: SEEKER_SERVER_URL
          value: https://seeker.npd.telstrahealth.com:8096
        - name: SEEKER_PROJECT_KEY
          value: Seeker-Project-Key
        - name: SEEKER_ACCESS_TOKEN
          valueFrom:
            secretKeyRef:
              name: seeker-access-token
              key: token
        command: ["node", "-r", "/run/seeker/seeker", "index.js"]
```

The application owner is responsible for configuring this, particularly including the annotation, environment variables and modifying the command.(note changing the command could also be achieved by editing the 'ENTRYPOINT' inside the Dockerfile). The location of the seeker module should not be changed as this is where the init container will copy the module to (i.e. always run `node -r /run/seeker/seeker`). 

Using the KPE provided Application Helm module (>=3.3.0)

```yaml
application:
  seeker: enabled
  seekerTech: nodejs
```

## Configuration

The webhook is deployed using the Helm chart under `/charts`. This deploys the app, a webhook configuration, a secret containing the TLS certificate and a configMap containing the Kuberentes resources to be injected under the `sidecarcofnig.yaml` key

```
containers:
- name: seeker
  image: {{ include "sidecar.image" . }}
  imagePullPolicy: IfNotPresent
  command: ["cp", "-r", "./seeker/node_modules/@synopsys-sig/seeker", "/run/seeker"]
  volumeMounts:
  - name: seeker-dir
    mountPath: /run/seeker
volumes:
- name: seeker-dir
  emptyDir: {}
volumeMounts:
- name: seeker-dir
  mountPath: /run/seeker
```

Note the command of the initContainer will copy the seeker agent to `/run/seeker` which is added as a volume and mounted into all containers. Therefore the command to run inside the main container should load seeker from `/run/seeker/seeker`.

## Known issues

* Only works with NodeJS and DotNetCore

### No initContainer injected

You may notice that the initContainer hasn't been injected. A few things to check:

* Annotations have been applied to the Pod spec not the Deployment
* Both annotations are present `seeker.drfoster.co/inject: enabled` and `seeker.drofster.co/tech: nodejs`

If these are correct then check the logs of the seeker-injector pod

```
kubectl -n seeker logs -l helm.io/chart=seeker-injector -c seeker-injector
```

You may see `remote error: tls: bad certificate`, the fix is to restart the pod

```
kubectl -n seeker-testing rollout retart deploy seeker-injector
```
