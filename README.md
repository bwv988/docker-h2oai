# H2O.ai Docker container

## Description

Experimental docker container for H20.ai.

## Usage

### Starting

```bash
docker run -it -p 54321:54321 --name h2oai --rm bwv988/h2oai
```

### Access H2O Web UI

<http://localhost:54321>

**Note:** Replace `localhost` with your Docker Machine IP when using Docker Machine (<https://docs.docker.com/machine/>)

### Interactive shell into container

```bash
docker exec -it bwv988/h2oai bash
```

### Stopping

```bash
docker stop h2oai
```
