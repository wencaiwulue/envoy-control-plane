FROM golang:1.17 as build

ENV GOPROXY="https://goproxy.cn,direct"

WORKDIR /build

COPY . /build/

RUN go mod download

RUN CGO_ENABLED=0 go build -o /build/mesh-manager ./main/main.go

FROM scratch

ENV TZ="Asia/Shanghai"
COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /build/mesh-manager /mesh-manager

CMD ["/mesh-manager"]
