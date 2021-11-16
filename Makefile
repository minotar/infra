
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

helm-upgrade: helm-upgrade-skind helm-upgrade-processd

helm-upgrade-skind:
	helm upgrade skind helm/charts/minotar-skind --namespace imgd --values helm/minotar-skind-values.yaml --values helm/mcclient-values.yaml

helm-upgrade-processd:
	helm upgrade processd helm/charts/minotar-processd --namespace imgd --values helm/minotar-processd-values.yaml

helm-upgrade-varnish:
	helm upgrade frontend-varnish helm/charts/mittwald-httpcache/chart --namespace imgd --values helm/mittwald-httpcache-frontend-values.yaml



helm-restart-skind:
	kubectl --namespace=imgd rollout restart sts skind-minotar-skind

helm-redeploy-skind:
	kubectl --namespace=imgd delete sts --cascade=orphan skind-minotar-skind
	${MAKE} helm-upgrade-skind
	${MAKE} helm-restart-skind

helm-restart-processd:
	kubectl --namespace=imgd rollout restart deployment processd-minotar-processd




helm-restart-varnish:
	kubectl --namespace=imgd rollout restart sts frontend-varnish-httpcache
