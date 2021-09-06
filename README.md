
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


## Helm



### Install
```
helm install imgd helm/charts/minotar-imgd --values helm/minotar-imgd-values.yaml
```

### Upgrade
```
helm upgrade imgd helm/charts/minotar-imgd --values helm/minotar-imgd-values.yaml
```



