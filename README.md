
## Prerequisites

A few tools are needed:
* Terraform
* `doctl`
* `kubectl`
* `helm`

A DigitalOcean Access Token is needed, add this to your env at `DIGITALOCEAN_ACCESS_TOKEN` so the Terraform provider picks it up

## Terraform

Optionally set the region in the `.tfvars` file. On first run, init Terraform with `terraform -chdir=terraform/ init`.

Further run cluster creation/updates with `terraform -chdir=terraform/ apply`.

## Kubernetes

While terraform has the kubeconfig, it's easiest to just use `doctl` (as you should already have it)

```
doctl kubernetes cluster kubeconfig save minotar-k8s
```

Create an imgd namespace for our associated services

```
kubectl create namespace imgd
```


## Helm

Set your extra mcclient vars `helm/mcclient-values.yaml`


```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Monitoring

```
helm install metrics-server bitnami/metrics-server --namespace kube-system --values helm/bitnami-metrics-server-values.yaml
```


```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --create-namespace --namespace kube-prometheus-stack --values helm/kube-prometheus-stack-values.yaml

```

### Floating IP

```
kubectl create namespace flipop
kubectl -n flipop create secret generic flipop-provider-tokens --from-literal=DIGITALOCEAN_ACCESS_TOKEN="${DIGITALOCEAN_ACCESS_TOKEN}"
```

```
helm install flipop helm/charts/minotar-flipop --namespace flipop
```

### Ingress

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

make helm-ingress-install
```

And subsequently, use `make helm-ingress-upgrade`



### App

* Minotar website via Nginx: `make helm-website-install` and `make helm-website-upgrade`

* Nginx Texture cache: `make helm-texture-install` and `make helm-texture-upgrade`

* skind: `make helm-skind-install` and `make helm-skind-upgrade`

* Frontend Varnish / "mittwald-httpcache": `make helm-varnish-install` and `make helm-varnish-upgrade`


* processd: `make helm-processd-install` and `make helm-processd-upgrade`

