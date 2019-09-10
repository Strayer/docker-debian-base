FROM golang:1.13-buster AS build

RUN cd / && \
      git clone https://github.com/AdguardTeam/dnsproxy.git && \
      cd dnsproxy && \
      git checkout f224dd9924ce7d5a002f0e2aa12c2df4d221dbc9 && \
      CGO_ENABLED=0 GOOS=linux go build

FROM scratch

COPY --from=build /dnsproxy/dnsproxy /dnsproxy

ENTRYPOINT [ "/dnsproxy" ]
