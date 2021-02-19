FROM alpine
LABEL VERSION=0.0.1

RUN set -ex \
        && apk update && apk upgrade \
        && apk add --no-cache tzdata git nodejs moreutils npm python3-dev py3-pip py3-cryptography jq curl \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone
        
# 创建工作目录
RUN mkdir /logs \
        && mkdir /pss \
        && cd /pss \
        && git init \
        && git remote add -f origin https://github.com/Aaron-lv/someDockerfile \
        && git config core.sparsecheckout true \
        && echo pack_some_script >> /pss/.git/info/sparse-checkout \
        && git pull origin master --rebase \
        && cp /pss/pack_some_script/crontab_list.sh /pss/crontab_list.sh

# github action 构建
COPY ./pack_some_script/docker_entrypoint.sh /usr/local/bin/
# 本地构建
# COPY ./docker_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker_entrypoint.sh \
        &&  crontab /pss/crontab_list.sh

#镜像构建版本,每次调整构建文件更新
ENV BUILD_VERSION=0.0.1 \
        DEFAULT_LIST_FILE=crontab_list.sh \
        CUSTOM_LIST_MERGE_TYPE=append

ENTRYPOINT ["docker_entrypoint.sh"]