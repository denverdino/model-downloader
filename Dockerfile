FROM alpine:latest
RUN apk add --no-cache jq ca-certificates git git-lfs
# 注意：alpine需要额外创建 lib64 的动态链接库软连接
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# 获取并安装阿里云 CLI 工具
ENV CLI_VERSION 3.0.251
RUN wget https://aliyuncli.alicdn.com/aliyun-cli-linux-${CLI_VERSION}-amd64.tgz \
    && tar -xvzf aliyun-cli-linux-${CLI_VERSION}-amd64.tgz \
    && rm aliyun-cli-linux-${CLI_VERSION}-amd64.tgz \
    && mv aliyun /usr/local/bin/

ENV OSSUTIL_VERSION 1.7.18
RUN wget https://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64 -O /usr/local/bin/ossutil \
    && chmod +x /usr/local/bin/ossutil
