## How it works

### Explain

- `dev.mesh.nocalhost.dev` is enable this feature
- `dev.mesh.nocalhost.dev/uuid` is an identifier, as node-id
- `dev.mesh.nocalhost.dev/type` is type, available value are: origin/dev
- `dev.mesh.nocalhost.dev/header-key` the mesh key
- `dev.mesh.nocalhost.dev/header-value` the mesh value, HTTP/GRPC with this header will route to this pod

### For example

annotation like this identify this is an origin route, default to those pod

```shell
      annotations:
        dev.mesh.nocalhost.dev: "true"
        dev.mesh.nocalhost.dev/uuid: "ca0b6df5"
        dev.mesh.nocalhost.dev/type: "origin"
```

annotation like this identify this is a dev route, traffic with this header will route to those pod

```shell
      annotations:
        dev.mesh.nocalhost.dev: "true"
        dev.mesh.nocalhost.dev/uuid: "ca0b6df5"
        dev.mesh.nocalhost.dev/type: "dev"
        dev.mesh.nocalhost.dev/header-key: "app"
        dev.mesh.nocalhost.dev/header-value: "v3"
```

## How to use it

### Clone repo

```shell
git clone https://github.com/wencaiwulue/envoy-control-plane.git
cd envoy-control-plane
kubectl apply -f sample/
```

### Get pod IP

```shell
➜  ~ kubectl get pods -owide
echoserver-v1-6bf8cdcdb8-2ntkm            2/2     Running     0          5m40s   192.168.0.41    10.0.0.8    <none>           <none>
echoserver-v2-6f94c5d54b-f77rr            2/2     Running     0          8m5s    192.168.0.93    10.0.0.3    <none>           <none>
echoserver-v3-7b7fdc84bf-pw282            2/2     Running     0          8m5s    192.168.0.40    10.0.0.8    <none>           <none>
➜  ~
```

## What we expected

Whoever receive traffic with header `app: v2` should redirect to pod `echoserver-v2-6f94c5d54b-f77rr`

Whoever receive traffic with header `app: v3` should redirect to pod `echoserver-v3-7b7fdc84bf-pw282`

Whoever receive traffic without header `app: v3` or `app: v2`  should redirect to pod `echoserver-v1-6bf8cdcdb8-2ntkm`

```shell
➜  ~ curl 192.168.0.41:8080 -H ''


Hostname: echoserver-v1-6bf8cdcdb8-2ntkm

Pod Information:
	node name:	N/A
	pod name:	echoserver-v1-6bf8cdcdb8-2ntkm
	pod namespace:	default
	pod IP:	192.168.0.41

Server values:
	server_version=nginx: 1.13.3 - lua: 10008

Request Information:
	client_address=192.168.0.41
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://192.168.0.41:8080/

Request Headers:
	accept=*/*
	host=192.168.0.41:8080
	user-agent=curl/7.64.1
	x-envoy-expected-rq-timeout-ms=15000
	x-forwarded-proto=http
	x-request-id=33704bcd-17c7-4f25-aee1-33b5d2a39f7b

Request Body:
	-no body in request-

➜  ~
```

```shell
➜  ~ curl 192.168.0.41:8080 -H 'app:v2'


Hostname: echoserver-v2-6f94c5d54b-f77rr

Pod Information:
	node name:	N/A
	pod name:	echoserver-v2-6f94c5d54b-f77rr
	pod namespace:	default
	pod IP:	192.168.0.93

Server values:
	server_version=nginx: 1.13.3 - lua: 10008

Request Information:
	client_address=192.168.0.93
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://192.168.0.41:8080/

Request Headers:
	accept=*/*
	app=v2
	host=192.168.0.41:8080
	user-agent=curl/7.64.1
	x-envoy-expected-rq-timeout-ms=15000
	x-forwarded-proto=http
	x-request-id=c18a22a7-e762-4ab1-9dfd-0920785c3ada

Request Body:
	-no body in request-

➜  ~
```

```shell
➜  ~ curl 192.168.0.41:8080 -H 'app:v3'


Hostname: echoserver-v3-7b7fdc84bf-pw282

Pod Information:
	node name:	N/A
	pod name:	echoserver-v3-7b7fdc84bf-pw282
	pod namespace:	default
	pod IP:	192.168.0.40

Server values:
	server_version=nginx: 1.13.3 - lua: 10008

Request Information:
	client_address=192.168.0.40
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://192.168.0.41:8080/

Request Headers:
	accept=*/*
	app=v3
	host=192.168.0.41:8080
	user-agent=curl/7.64.1
	x-envoy-expected-rq-timeout-ms=15000
	x-forwarded-proto=http
	x-request-id=a517bdee-0a48-4549-b024-4d6f67e30e72

Request Body:
	-no body in request-

➜  ~
```

