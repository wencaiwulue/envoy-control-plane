.PHONY: envoy-image
envoy-image:
	docker build -t naison/envoy:v1.21.0-with-iptables -f ./envoy/Dockerfile envoy
	docker push naison/envoy:v1.21.0-with-iptables

.PHONY: mesh-image
mesh-image:
	docker build -t naison/mesh-manager:v0.0.1 -f ./Dockerfile .
	docker push naison/mesh-manager:v0.0.1


