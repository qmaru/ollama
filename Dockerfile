FROM ollama/ollama AS ollama
FROM cgr.dev/chainguard/wolfi-base

RUN apk add --no-cache libstdc++

COPY --from=ollama /usr/bin/ollama /usr/bin/ollama
COPY --from=ollama /usr/lib/ollama/libggml-base* /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu* /usr/lib/ollama/

ENV OLLAMA_HOST=0.0.0.0

EXPOSE 11434/tcp

CMD ["ollama", "serve"]
