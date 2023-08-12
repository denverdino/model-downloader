# A set of helper container images

## Helper images

* alibaba-cloud-helper: A simple helper for Alibaba Cloud CLI and OSSUtil
* model-downloader: A simple helper for downloading Huggingface models to cache
* ollama-model-downloader: A simple helper for downloading Ollama models to cache

## Usage

You can download the ollama/huggingface models to OSS as local cache.
Please modify the files in `deploy` directory to your needs. 

### Downloading ollama models

```bash
kubectl apply -f deploy/oss-secret.yaml
kubectl apply -f deploy/ollama-pvc.yaml
kubectl apply -f deploy/ollama-model-downloader-job.yaml
kubectl get jobs
```

### Downloading huggingface models

```bash
kubectl apply -f deploy/oss-secret.yaml
kubectl apply -f deploy/hf-pvc.yaml
kubectl apply -f deploy/model-downloader-job.yaml
kubectl get jobs
```

