
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

### Install

#### Monitoring

```
helm install metrics-server bitnami/metrics-server --namespace kube-system --values helm/bitnami-metrics-server-values.yaml
```


```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --create-namespace --namespace kube-prometheus-stack --values helm/kube-prometheus-stack-values.yaml

```

#### Floating IP

```
kubectl create namespace flipop
kubectl -n flipop create secret generic flipop-provider-tokens --from-literal=DIGITALOCEAN_ACCESS_TOKEN="${DIGITALOCEAN_ACCESS_TOKEN}"
```

```
helm install flipop helm/charts/minotar-flipop --namespace flipop
```


#### App

Minotar website via Caddy:
```
helm install frontend-website helm/charts/minotar-caddy --namespace imgd --values helm/minotar-caddy-values.yaml
```

skind:
```
helm install skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml
```

Frontend Varnish / "mittwald-httpcache":
```
helm install frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml
```

processd:
```
helm install processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml
```



### Upgrade

Minotar website via Caddy:
```
helm upgrade frontend-website helm/charts/minotar-caddy --namespace imgd --values helm/minotar-caddy-values.yaml
```

skind:
```
helm upgrade skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml
```

Frontend Varnish / "mittwald-httpcache":
```
helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml
```

processd:
```
helm upgrade processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml
```
