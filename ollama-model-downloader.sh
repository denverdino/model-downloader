#!/bin/sh

# Refer https://www.andreagrandi.it/posts/how-to-workaround-ollama-pull-issues/ for more details

die(){
  echo "$1"
  exit 1
}

#DRYRUN=echo

_=$(command -v jq) || die "Need jq"
_=$(command -v curl) || die "Need curl"

[ -z "$1" ] && die "usage: $0 modelname"

name=${1%%:*}
[[ "$1" = *:* ]] && tag="${1##*:}" || tag=latest

OLLAMA_MODELS=${OLLAMA_MODELS-~/.ollama/models}
CURL_OPTS="--retry 5 --retry-delay 5 --retry-max-time 0 -#L -C -"

cd $OLLAMA_MODELS || die "Couldn't cd to OLLAMA_MODELS ($OLLAMA_MODELS)"
[ ! -d blobs -o ! -d manifests ] && die "Missing blobs or manifests directory"
manifest_dir="manifests/registry.ollama.ai/library/$name"
#[ -e "$manifest_dir/$tag" ] && die "$name:$tag already exists"
[ ! -d "$manifest_dir" ] && { $DRYRUN mkdir -p "$manifest_dir" || die "Couldn't mkdir manifest dir ($manifest_dir)" ; }

manifest=$(curl -sL https://registry.ollama.ai/v2/library/$name/manifests/$tag) || die "Couldn't fetch manifest"
errors=$(jq -cn "$manifest |.errors")
[ "$errors" = "null" ] || die "$errors"

config=$(jq -rn "$manifest | .config.digest") || die "No config digest"

$DRYRUN curl $CURL_OPTS -o blobs/${config/:/-} https://registry.ollama.ai/v2/library/$name/blobs/$config || die "Couldn't fetch config blob"

for layer in $(jq -rn "$manifest | .layers[].digest") ; do
  $DRYRUN curl $CURL_OPTS -o blobs/${layer/:/-} https://registry.ollama.ai/v2/library/$name/blobs/$layer || die "Couldn't fetch layer"
done

[ -n "$DRYRUN" ] && echo "echo '$manifest' > '$manifest_dir/$tag'" || { echo "$manifest" > "$manifest_dir/$tag" || die "Couldn't write manifest" ; }
