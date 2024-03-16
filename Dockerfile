FROM golang:1.21 AS build

WORKDIR /go/src/goatcounter

COPY . .

RUN go build -ldflags="-X zgo.at/goatcounter/v2.Version=$(git log -n1 --format='%h_%cI')" ./cmd/goatcounter

FROM debian:bookworm-slim AS runtime

COPY --from=build /go/src/goatcounter/goatcounter /usr/local/bin

WORKDIR /home/user

RUN mkdir /home/user/db

VOLUME ["/home/user/db/"]
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/goatcounter", "serve", "-tls", "proxy", "-listen", ":80"]
CMD ["help"]