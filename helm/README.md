



Get the JSON config for a specific Helm Release and Revision:
```
RELEASE=skind REVISION=1 kubectl get secret --namespace imgd sh.helm.release.v1.${RELEASE}.v${REVISION} -o jsonpath='{.data.release}' | base64 --decode | base64 --decode | gzip -cd | jq '.'
```
