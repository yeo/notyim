include envs

k := kubectl

export version

deploy:
	envsubst < deployment.yaml | $(k) apply -f -
