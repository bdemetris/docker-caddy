# docker-caddy

A simple workflow for building a docker container with caddy, and a basic html page.

## Requirements

`docker` must be installed on the host machine and added to `PATH`

## Getting Started

`git clone https://github.com/bdemetris/docker-caddy.git`


### Build Caddy

`make build` will create a `/build` folder local to the `Makefile` and make the `caddy` binary available.

*optionally set the `COMMIT` variable in the `Dockerfile` to a commit sha from [caddy's release page](https://github.com/caddyserver/caddy/releases)*

### Build/Run the Container

`make run` will build the docker image and run the container with the appropriate flags to map port 8080 on the host to the container.

Visit [http://localhost:8080/](http://localhost:8080/) once the process is complete