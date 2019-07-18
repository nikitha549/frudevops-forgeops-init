# ForgeRock DevOps and Cloud Deployment - Skaffold Preview Branch

Kubernetes DevOps artifacts for the ForgeRock platform.

** This branch is a preview of the upcoming 7.x workflow using skaffold and kustomize **

Please see the [skaffold readme](README-skaffold.md).

This GitHub repository is a read-only mirror of 
ForgeRock's [https://stash.forgerock.org/projects/CLOUD/repos/forgeops] (Bitbucket Server repository). Users
with BackStage accounts can make pull requests on our Bitbucket Server repository. ForgeRock does not 
accept pull requests on this GitHub mirror.

## Disclaimer

These samples are provided on an “as is” basis, without warranty of any kind, to the fullest extent
permitted by law. ForgeRock does not warrant or guarantee the individual success developers
may have in implementing the code on their development platforms or in
production configurations. ForgeRock does not warrant, guarantee or make any representations
regarding the use, results of use, accuracy, timeliness or completeness of any data or
information relating to these samples. ForgeRock disclaims all warranties, expressed or implied, and
in particular, disclaims all warranties of merchantability, and warranties related to the code, or any
service or software related thereto. ForgeRock shall not be liable for any direct, indirect or
consequential damages or costs of any type arising out of any action taken by you or others related
to the samples.


## Contents 

* `kustomize` - Kustomize manifests for deploying the platform. See [README-skaffold.md](README-skaffold.md)
* `helm/` - Helm charts. NOT Used in this branch. Here for reference.
* `etc/` - contains various scripts and utilities
* `bin/`  - Utility shell scripts to deploy the helm charts and create and manage clusters.



## Documentation 

The [Draft ForgeRock DevOps Guide](https://ea.forgerock.com/docs/platform/devops-guide-minikube/index.html#devops-implementation-env-about-the-env)
tracks the master branch.

The documentation for the current release can be found on
[backstage](https://backstage.forgerock.com/docs/platform).


## Setting a namespace

If you do not want to use the 'default' namespace, set your namespace using:

```
kubectl config set-context $(kubectl config current-context) --namespace=<insert-namespace-name-here>
```

The `kubectx` and `kubens` utilities are recommended.

## Troubleshooting

Refer to the toubleshooting chapter in the [DevOps Guide](https://backstage.forgerock.com/docs/platform/6/devops-guide/#chap-devops-troubleshoot).

Troubleshooting suggestions:

* The script `bin/debug-log.sh` will generate an HTML file with log output. Useful for troubleshooting.
* Simplify. Deploy a single product at a time (for example, ds), and make sure it is working correctly before deploying the next product. 
* Describe a failing pod using `kubectl get pods; kubectl describe pod pod-xxx`
    1. Look at the event log for failures. For example, the image can't be pulled.
    2. Examine all the init containers. Did each init container complete with a zero (success) exit code? If not, examine the logs from that failed init container using `kubectl logs pod-xxx -c init-container-name`
    3. Did the main container enter a crashloop? Retrieve the logs using `kubectl logs pod-xxx`.
    4. Did a docker image fail to be pulled?  Check for the correct docker image name and tag. If you are using a private registry, verify your image pull secret is correct.
    5. You can use `kubectl logs -p pod-xxx` to examine the logs of previous (exited) pods.
* If the pods are coming up successfully, but you can't reach the service, you likely have ingress issues:
    1. Use `kubectl describe ing` and `kubectl get ing ingress-name -o yaml` to view the ingress object.
    2. Describe the service using `kubectl get svc; kubectl describe svc xxx`.  Does the service have an `Endpoint:` binding? If the service endpoint binding is not present, it means the service did not match any running pods.
* Determine if your cluster is having issues (not enough memory, failing nodes). Watch for pods killed with OOM (Out of Memory). Commands to check:
    1. `kubectl describe node`
    2. `kubectl get events -w`
* Most images provide the ability to exec into the pod using bash, and examine processes and logs.  Use `kubectl exec pod-name -it bash`.
* If you wish to backup the directory server, the Kubernetes cluster must support a read-write-many (RWX) volume type, such as NFS, or Minikube's hostpath provisioner. You can describe persistent volumes using `kubectl describe pvc`. If a PVC is in a pending state, your cluster may not support the required storage class.
