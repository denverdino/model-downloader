FROM python:3.10-slim
USER root
RUN pip install --no-cache-dir huggingface_hub
ENV MODEL_NAME Qwen/Qwen2.5-0.5B
ENV TARGET_CACHE /huggingface
COPY hf-model-downloader.py .
CMD [ "python", "-u", "hf-model-downloader.py" ]