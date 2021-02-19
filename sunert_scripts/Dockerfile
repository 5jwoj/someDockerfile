FROM alpine
LABEL VERSION=0.0.1

RUN set -ex \
        && apk update && apk upgrade \
        && apk add --no-cache tzdata moreutils git nodejs npm curl jq \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

# 创建工作目录
RUN mkdir /logs \
        && mkdir /pss \
        && cd /pss \
        && git init \
        && git remote add -f origin https://github.com/Aaron-lv/someDockerfile \
        && git config core.sparsecheckout true \
        && echo sunert_scripts >> /pss/.git/info/sparse-checkout \
        && git pull origin master --rebase \
        && cp /pss/sunert_scripts/crontab_list.sh /pss/crontab_list.sh


# 克隆Sunert脚本仓库
RUN git clone https://github.com/Sunert/Scripts /Scripts \
        && cd /Scripts \
        && git checkout master \
        && npm install

# github action 构建
COPY ./sunert_scripts/docker_entrypoint.sh /usr/local/bin/
# 本地构建
# COPY ./docker_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker_entrypoint.sh \
        &&  crontab /pss/crontab_list.sh

#镜像构建版本,每次调整构建文件更新
ENV BUILD_VERSION=0.0.1 \
        DEFAULT_LIST_FILE=crontab_list.sh \
        CUSTOM_LIST_MERGE_TYPE=append

WORKDIR /Scripts

ENTRYPOINT ["docker_entrypoint.sh"]