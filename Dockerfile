FROM alpine:edge
RUN apk add -U make llvm-static yaml-static sqlite-static libssh2-static zlib-static libretls-static openssl-libs-static openssl-dev openssl crystal shards
RUN mkdir /ecmo
COPY . /ecmo
WORKDIR /ecmo
RUN shards update
RUN crystal build --release --static /ecmo/src/app.cr -o /ecmo/dist/ecmo-linux-x86-64.bin
ENTRYPOINT ["/ecmo/dist/ecmo-linux-x86-64.bin"]
EXPOSE 3000
