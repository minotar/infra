



### Instal
```
helm install imgd charts/minotar-imgd --values minotar-imgd-values.yaml
```

### Upgrade
```
helm upgrade imgd charts/minotar-imgd --values minotar-imgd-values.yaml
```




### Instal
```
helm install uuid-cache bitnami/redis-cluster --timeout 600s --values redis-common-values.yaml --values redis-values-uuid-cache.yaml --set cluster.init=true --values redis-values-dev.yaml

helm install userdata-cache bitnami/redis-cluster --timeout 600s --values redis-common-values.yaml --values redis-values-userdata-cache.yaml --set cluster.init=true --values redis-values-dev.yaml
```

### Upgrade
```
helm upgrade uuid-cache bitnami/redis-cluster --values redis-common-values.yaml --values redis-values-uuid-cache.yaml --values redis-values-dev.yaml
```

helm upgrade userdata-cache bitnami/redis-cluster --values redis-common-values.yaml --values redis-values-userdata-cache.yaml --values redis-values-dev.yaml
```
```
