import os
import shutil

from huggingface_hub import snapshot_download

def copy_directory(src, dst):
    if not os.path.exists(dst):
        os.makedirs(dst)

    for item in os.listdir(src):
        src_path = os.path.join(src, item)
        dst_path = os.path.join(dst, item)

        if os.path.isdir(src_path):
            copy_directory(src_path, dst_path)
        elif os.path.islink(src_path):
            if not os.path.exists(dst_path):
                link_target = os.readlink(src_path)
                os.symlink(link_target, dst_path)
                print(f"symlink: from {link_target} to {dst_path}")
            else:
                print(f"Skipping existing link: {dst_path}")
        elif os.path.isfile(src_path):
            if not os.path.exists(dst_path):
                print(f"copy file from {src_path} to {dst_path}")
                shutil.copy2(src_path, dst_path)
            else:
                print(f"Skipping existing file: {dst_path}")

model_name = os.environ.get("MODEL_NAME")

print(f"Start to download model: {model_name} ...")
#model = AutoModel.from_pretrained(model_name, local_files_only=True)
#print(f"Start to download tokenizer: {model_name} ...")
#tokenizer = AutoTokenizer.from_pretrained(model_name)
# Download the model files to the default cache directory
model_path = snapshot_download(repo_id=model_name)
print(f"Model downloaded to: {model_path}")

src_dir = os.environ.get("HF_HOME", "/root/.cache/huggingface")

dst_dir = os.environ.get("TARGET_CACHE")

print(f"Start to copy files from {src_dir} to {dst_dir} ...")

copy_directory(src_dir, dst_dir)

print(f"All files copied from {src_dir} to {dst_dir} successfully!")
