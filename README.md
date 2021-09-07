
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

skind:
```
helm install skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml
```

skind Varnish / "mittwald-httpcache":
```
helm install skind-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-skind-values.yaml
```

processd:
```
helm install processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml
```


processd/website/frontend Varnish / "mittwald-httpcache":
```
helm install frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml
```



### Upgrade

skind:
```
helm upgrade skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml
```

skind Varnish / "mittwald-httpcache":
```
helm upgrade skind-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-skind-values.yaml
```

processd:
```
helm upgrade processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml
```

processd/website/frontend Varnish / "mittwald-httpcache":
```
helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml
```
