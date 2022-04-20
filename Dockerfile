FROM alpine:edge
RUN apk add -U make llvm-static yaml-static sqlite-static libssh2-static zlib-static libretls-static openssl-libs-static openssl-dev openssl crystal shards
WORKDIR /ecmo
RUN shards update
RUN crystal build --release --static /ecmo/src/app.cr -o /ecmo/dist/ecmo-linux-x64.bin
