# App_GKE

Technologies:
_________________________________________________________________________________________________________________________________________________________________
.Teraform
.Argocd
.Prometheus
.Grafana
.Docker
.Python

Features:
_________________________________________________________________________________________________________________________________________________________________
- A kubernetes architecture on gcp considering publishing the application using the load balancing and security best practices.
- Deployment of you application from VCS and source repository should be fully automated where any change to the code results with changing the
  application on the production environment (google cloud build).
- The CD part of your application should use a GitOps approach where your kubernetes should bring the container from the source artifacts.
- Your application should be based on multiple clusters, segregation management and application workloads.
- Monitoring and logging observations functionality should be added ( grafana, prometheus)
- You architecture should follow VPC design and security best practices.
- Your architecture should follow IaC best practices while deploying your architecture in a fully code-based and automated approach, changes to IaC
  code should be automatically reflected to your environment.
_________________________________________________________________________________________________________________________________________________________________
Steps for Project:
___________________________________________________________________________________________________________________________________________________________________

1.Create Service account on google cloud and add key to use it in the project, also Create cloud storage for backend statefile of terraform.

2.Terraform:
  Create infrastructure as code (Iac) by using terraform on Google cloud (GCP) 
    provision: VPC, Subnet, Security group, GKE, Node pool
    *Note: create two clusters in (us-central1, us-east4)
___________________________________________________________________________________________________________________________________________________________________
    
3- Continuous Integration(CI): build docker file & push image on artifact registry(gcr) by using cloudbuild.yaml file.
_______________________________________________________________________________________________________________________________________________________________________________________________________________

4- Continuous Deployment(CD): install ArgoCD on primary cluster and add secondary cluster to deploy application. 
    
*gcloud container clusters get-credentials gke-cicd-422619-gke-primary --zone us-central1-f --project gke-cicd-422619      #connect primary cluster

*kubectl get nodes      #verify setup


*kubectl config get-contexts
*kubectl config use- context add [primary name] #switch to primary cluster
*Kubectl config current-context


then:
Install Argo CD:
________________
*kubectl create namespace argocd

*kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

*kubectl get pods -n argocd

*brew install argocd

*argocd cluster add

*kubectl config get-contexts

*argocd login [ip server of argocd]

*argocd cluster add [secondary cluster] --server  [ip server of argocd:port no]        #add the second cluster

_____________________________________________________________________________________________________________________________________________________________________________________________________________

5.Install Prometheus, node exporter & Grafana to monitor and log observations functionality. 


*gcloud container clusters get-credentials gke-cicd-422619-gke-primary --zone us-central1-f --project gke-cicd-422619   #connect primary cluster

*kubectl get nodes    #verify setup
    
*Deploy node exporter:  kubectl apply -f Kubernetes/node-exporter
  -create namespace
  -create service account cluster role
  -create cluster role binding to deploy node exporter
  -create daemonset
  -create pod-monitoring: managed collection operator provides two main   custom resources port monitoring if all ports are deployed in the same namespace & cluster port monitoring in case ports are spread between multiple namespaces for a given application.

kubectl get podmonitoring -n monitoring
kubectl get pods -n gmp-system
kubectl get sa -n gmp-system
kubectl get sa collector -o yaml -n gmp-system

kubectl annotate serviceaccount collector \ --namespace gmp-system #add annotation to Kubernetes series account

kubectl get pods -n gmp-system
kubectl delete collector-9p7jm collector-kktlv -n gmp-system
kubectl logs -n gmp-system -l app=managed-prometheus-collector -f 
__________________________________________________________________________________________________________________________________________________________________________________________________________

6. Using ArgoCD with HashiCorp vault to gather secrets.
