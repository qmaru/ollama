# ollama cpu-only

Lightweight CPU-only build, always tracking the latest [ollama](https://hub.docker.com/r/ollama/ollama) release

## Build

```shell
# build
docker build -t ollama:cpu .

# local
docker compose up --build

# remote
docker compose pull
docker compose up --no-build
```

## Credit

[alpine/ollama](https://hub.docker.com/r/alpine/ollama)

[@kth8](https://github.com/ollama/ollama/issues/7184#issuecomment-2414823298)
