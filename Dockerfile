FROM golang:1.16 as builder
WORKDIR /app
ADD ./go.mod go.sum /app/
RUN go mod download
ADD ./ /app/

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -ldflags "-w -s -extldflags \"-static\""

# Executable image
FROM alpine:3.12
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/snat-race-conn-test /app/snat-race-conn-test
WORKDIR /app
ENTRYPOINT ["/app/snat-race-conn-test"]
