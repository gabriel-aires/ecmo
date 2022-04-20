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
sudo setenforce permissive 			# needed for fedora, rhel, centos
sudo dnf install openssl			# used for signing certificates
docker build . -t ecmo -v $(pwd):/ecmo		# podman is preferred in fedora, cli arguments are the same
sudo ./dist/ecmo-linux-x64.bin --install	# installs binaries, recipes and data to /opt/ecmo
sudo ./dist/ecmo-linux-x64.bin --tls		# creates self-signed certificate
sudo ./dist/ecmo-linux-x64.bin --config systemd	# creates systemd service configuration
sudo systemctl enable ecmo			# enables ecmo on boot
sudo systemctl start ecmo			# start service according to params in /opt/ecmo/ecmo.conf
```

1) needed for fedora, rhel, centos
2) used for signing certificates
3) podman is preferred in fedora, cli arguments are the same
4) installs binaries, recipes and data to /opt/ecmo
5) creates self-signed certificate
6) creates systemd service configuration
7) enables ecmo on boot
8) start service using configuration defined in /opt/ecmo/ecmo.conf

###### TLDR :)

![Application Screenshot](https://raw.githubusercontent.com/gabriel-aires/ecmo/main/doc/welcome-screen.png)

