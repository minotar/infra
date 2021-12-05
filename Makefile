
## Docs
.PHONY: plantuml-jetty-start plantuml-jetty-stop

plantuml-jetty-start:
	@docker run --name plantuml_jetty --rm -d -p 8081:8080 plantuml/plantuml-server:jetty

plantuml-jetty-stop:
	@docker kill plantuml_jetty

docs/Prod.png: docs/prod.plantuml
	-curl --silent --show-error --fail -H "Content-Type: text/plain" --data-binary @docs/prod.plantuml http://localhost:8081/png/ --output docs/Prod.png


## terraform
.PHONY: terraform-init terraform-apply

terraform-init:
	terraform -chdir=terraform/ init

terraform-apply:
	terraform -chdir=terraform/ apply


## ansible
.PHONY: ansible-deploy ansible-check

ansible-deploy:
	ansible-playbook -i ansible/hosts -e @ansible/custom-vars.yml ansible/playbook.yml

ansible-check:
	ansible-playbook -i ansible/hosts -e @ansible/custom-vars.yml ansible/playbook.yml


## helm / kube
.PHONY: helm-repos k8-namespaces k8-top

helm-repos:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

k8-namespaces:
	kubectl create namespace kube-prometheus-stack
	kubectl create namespace imgd
	kubectl create namespace web
	kubectl create namespace flipop
	kubectl create namespace nginx-ingress

k8-top:
	kubectl top nodes
	kubectl top pods -A --sort-by=memory | head

### Install/Upgrade

#### Metrics
.PHONY: helm-metrics-install helm-metrics-upgrade helm-prometheus-install helm-prometheus-upgrade

helm-metrics-install:
	helm install metrics-server bitnami/metrics-server --namespace kube-system --values helm/bitnami-metrics-server-values.yaml
helm-metrics-upgrade:
	helm upgrade metrics-server bitnami/metrics-server --namespace kube-system --values helm/bitnami-metrics-server-values.yaml

helm-prometheus-install:
	helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace kube-prometheus-stack --values helm/kube-prometheus-stack-values.yaml
helm-prometheus-upgrade:
	helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace kube-prometheus-stack --values helm/kube-prometheus-stack-values.yaml

#### Flipop
.PHONY: helm-flipop-install helm-flipop-upgrade

helm-flipop-install:
	helm install flipop helm/charts/minotar-flipop --namespace flipop --values helm/minotar-flipop-values.yaml
helm-flipop-upgrade:
	helm upgrade flipop helm/charts/minotar-flipop --namespace flipop --values helm/minotar-flipop-values.yaml

#### Ingress
.PHONY: helm-ingress-install helm-ingress-upgrade

helm-ingress-install:
	helm install ingress ingress-nginx/ingress-nginx --namespace nginx-ingress --values helm/ingress-nginx-values.yaml
helm-ingress-upgrade:
	helm upgrade ingress ingress-nginx/ingress-nginx --namespace nginx-ingress --values helm/ingress-nginx-values.yaml

#### skind/processd (imgd)
.PHONY: helm-imgd-upgrade helm-skind-install helm-skind-upgrade helm-processd-install helm-processd-upgrade

# eg. New containers for release, upgrade both
helm-imgd-upgrade: helm-skind-upgrade helm-processd-upgrade

helm-skind-install:
	helm install skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml
helm-skind-upgrade:
	helm upgrade skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml

helm-processd-install:
	helm install processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml
helm-processd-upgrade:
	helm upgrade processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml

#### Frontend Varnish
.PHONY: helm-varnish-install helm-varnish-upgrade

helm-varnish-install:
	helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml
helm-varnish-upgrade:
	helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml

#### Website
.PHONY: helm-website-install helm-website-upgrade

helm-website-install:
	helm install frontend-website helm/charts/minotar-website --namespace web --values helm/minotar-website-values.yaml
helm-website-upgrade:
	helm upgrade frontend-website helm/charts/minotar-website --namespace web --values helm/minotar-website-values.yaml

### Operations
.PHONY: helm-skind-restart helm-skind-redeploy helm-processd-restart helm-varnish-restart

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
