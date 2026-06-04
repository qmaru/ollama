FROM ollama/ollama AS ollama

# compress ollama core binary with upx
FROM cgr.dev/chainguard/wolfi-base AS builder

RUN apk add --no-cache upx

COPY --from=ollama /usr/bin/ollama /usr/bin/ollama
RUN upx --best --lzma /usr/bin/ollama

FROM cgr.dev/chainguard/wolfi-base AS ollama-libs

ARG TARGETARCH

COPY --from=ollama /usr/lib/ollama/ /usr/lib/ollama/

RUN cd /usr/lib/ollama \
    && rm -rf cuda* llama-quantize libllama-quantize-impl.so  \
    && if [ "$TARGETARCH" = "amd64" ]; then \
         rm -rf vulkan* mlx* \
           libggml-cpu-piledriver.so \
           libggml-cpu-sandybridge.so \
           libggml-cpu-sse42.so \
           libggml-cpu-ivybridge.so; \
       fi

# Final image

FROM cgr.dev/chainguard/wolfi-base

RUN apk add --no-cache libstdc++

COPY --from=builder /usr/bin/ollama /usr/bin/ollama
COPY --from=ollama-libs /usr/lib/ollama/ /usr/lib/ollama/

ENV OLLAMA_HOST=0.0.0.0

EXPOSE 11434/tcp

CMD ["ollama", "serve"]
