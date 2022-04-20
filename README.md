# Ecmo

Easy Configuration Management Orchestration:

* Infrastructure as Code 
* Hardware Resources Dashboard
* RESTful API for machine metrics
* Time-Series Visualization 
* Job Creator / Scheduler
* Easy agent installation: standalone binary, courtesy of crystal-lang, mruby, sqlite, alpine-linux and musl-libc
* Credits to [mitamae](https://github.com/itamae-kitchen/mitamae), [dygraphs](https://github.com/danvk/dygraphs), [htmx](https://github.com/bigskysoftware/htmx), [spider-gazelle](https://github.com/spider-gazelle/spider-gazelle), [gralig](https://github.com/erenesto/gralig), [feather](https://github.com/feathericons/feather) and many others!

###### Why another tool?

[Presentation (in Portuguese)](https://github.com/gabriel-aires/ecmo/raw/main/doc/gestao_configuracao.pdf)

###### Docker/Podman Setup

```
sudo setenforce permissive
sudo dnf install openssl
docker build . -t ecmo -v $(pwd):/ecmo
sudo ./dist/ecmo-linux-x64.bin --install
sudo ./dist/ecmo-linux-x64.bin --tls
sudo ./dist/ecmo-linux-x64.bin --config systemd
sudo systemctl enable ecmo
sudo systemctl start ecmo
```

1) needed for fedora, rhel, centos
2) used for signing certificates
3) podman is preferred in fedora, cli arguments are the same
4) installs binaries, recipes and data to /opt/ecmo
5) creates self-signed certificate
6) creates systemd service configuration
7) enables ecmo on boot
8) starts service using configuration defined in /opt/ecmo/ecmo.conf

###### TLDR :)

![Application Screenshot](https://raw.githubusercontent.com/gabriel-aires/ecmo/main/doc/welcome-screen.png)

