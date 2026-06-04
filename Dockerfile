FROM ollama/ollama AS ollama

FROM cgr.dev/chainguard/wolfi-base AS builder

RUN apk add --no-cache upx

COPY --from=ollama /usr/bin/ollama /usr/bin/ollama

RUN upx --best --lzma /usr/bin/ollama

FROM cgr.dev/chainguard/wolfi-base

RUN apk add --no-cache libstdc++

# core
COPY --from=builder /usr/bin/ollama /usr/bin/ollama
# base
COPY --from=ollama /usr/lib/ollama/libggml-base.so* /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml.so* /usr/lib/ollama/
# ggml cpu backends (AVX2+ / AVX512 / Zen4, x64 fallback)
COPY --from=ollama /usr/lib/ollama/libggml-cpu-haswell.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-alderlake.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-cannonlake.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-cascadelake.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-cooperlake.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-icelake.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-sapphirerapids.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-skylakex.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-zen4.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libggml-cpu-x64.so /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libgomp.so* /usr/lib/ollama/
# llama deps
COPY --from=ollama /usr/lib/ollama/libllama.so* /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libllama-common.so* /usr/lib/ollama/
COPY --from=ollama /usr/lib/ollama/libllama-server-impl.so /usr/lib/ollama/
# llama multimodal
COPY --from=ollama /usr/lib/ollama/libmtmd.so* /usr/lib/ollama/
# llama-server
COPY --from=ollama /usr/lib/ollama/llama-server /usr/lib/ollama/

ENV OLLAMA_HOST=0.0.0.0

EXPOSE 11434/tcp

CMD ["ollama", "serve"]
