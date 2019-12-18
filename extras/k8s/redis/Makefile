NAMESPACE := noty
K 			  := kubectl -n $(NAMESPACE)

ns:
	kubectl create ns $(NAMESPACE)

secret:
	envsubst < secret.yaml | $(K) apply -f -

deploy:
	$(K) apply -f statefulset.yaml

password:
	$(K) -n mongodb log mongodb-0 | grep PASSWORD
