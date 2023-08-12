FROM alpine:latest
RUN apk add --no-cache jq curl

COPY ollama-model-downloader.sh .
ENTRYPOINT ["./ollama-model-downloader.sh"]
