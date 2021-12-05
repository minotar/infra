
## Docs

plantuml-jetty-start:
	@docker run --name plantuml_jetty --rm -d -p 8081:8080 plantuml/plantuml-server:jetty

plantuml-jetty-stop:
	@docker kill plantuml_jetty

docs/Prod.png: docs/prod.plantuml
	-curl --silent --show-error --fail -H "Content-Type: text/plain" --data-binary @docs/prod.plantuml http://localhost:8081/png/ --output docs/Prod.png


## terraform

terraform-init:
	terraform -chdir=terraform/ init

terraform-apply:
	terraform -chdir=terraform/ apply


## ansible

ansible-deploy:
	ansible-playbook -i ansible/hosts -e @ansible/custom-vars.yml ansible/playbook.yml

ansible-check:
	ansible-playbook -i ansible/hosts -e @ansible/custom-vars.yml ansible/playbook.yml


## helm / kube


### Install/Upgrade

k8-namespaces:
	kubectl create namespace imgd
	kubectl create namespace web
	kubectl create namespace nginx-ingress


helm-flipop-install:
	helm install flipop helm/charts/minotar-flipop --namespace flipop --values helm/minotar-flipop-values.yaml
helm-flipop-upgrade:
	helm upgrade flipop helm/charts/minotar-flipop --namespace flipop --values helm/minotar-flipop-values.yaml


helm-ingress-install:
	helm install ingress ingress-nginx/ingress-nginx --namespace nginx-ingress --values helm/ingress-nginx-values.yaml
helm-ingress-upgrade:
	helm upgrade ingress ingress-nginx/ingress-nginx --namespace nginx-ingress --values helm/ingress-nginx-values.yaml


# eg. New containers for release, upgrade both
helm-imgd-upgrade: helm-skind-upgrade helm-processd-upgrade


helm-texture-install:
	helm install texture-cache bitnami/nginx --namespace imgd --values helm/bitnami-nginx-texture-cache-values.yaml
helm-texture-upgrade:
	helm upgrade texture-cache bitnami/nginx --namespace imgd --values helm/bitnami-nginx-texture-cache-values.yaml


helm-skind-install:
	helm install skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml
helm-skind-upgrade:
	helm upgrade skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml


helm-processd-install:
	helm install processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml
helm-processd-upgrade:
	helm upgrade processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml


helm-varnish-install:
	helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml
helm-varnish-upgrade:
	helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml


helm-website-install:
	helm install frontend-website helm/charts/minotar-website --namespace web --values helm/minotar-website-values.yaml
helm-website-upgrade:
	helm upgrade frontend-website helm/charts/minotar-website --namespace web --values helm/minotar-website-values.yaml




### Operations


helm-skind-restart:
	kubectl --namespace=imgd rollout restart sts skind-minotar-skind

helm-skind-redeploy:
	kubectl --namespace=imgd delete sts --cascade=orphan skind-minotar-skind
	${MAKE} helm-skind-upgrade
	${MAKE} helm-skind-restart


helm-processd-restart:
	kubectl --namespace=imgd rollout restart deployment processd-minotar-processd




helm-varnish-restart:
	kubectl --namespace=imgd rollout restart sts frontend-varnish-httpcache
