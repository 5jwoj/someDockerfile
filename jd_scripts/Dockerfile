FROM alpine
LABEL AUTHOR="none" \
        VERSION=0.1.4

ARG SSH_PRIVATE_KEY

ENV DEFAULT_LIST_FILE=crontab_list.sh \
        CUSTOM_LIST_MERGE_TYPE=append \
        COOKIES_LIST=/scripts/logs/cookies.list \
        REPO_URL=git@github.com:Aaron-lv/jd_scripts \
        REPO_BRANCH=master

RUN set -ex \
        && apk update && apk upgrade \
        && apk add --no-cache tzdata git nodejs moreutils npm curl jq openssh-client \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /root/.ssh \
        && echo -e $SSH_PRIVATE_KEY > /root/.ssh/id_rsa \
        && chmod 600 /root/.ssh/id_rsa \
        && ssh-keyscan github.com > /root/.ssh/known_hosts

RUN git clone -b $REPO_BRANCH $REPO_URL /scripts \
        && cd /scripts \
        && mkdir logs \
        && npm install

RUN mkdir /jds \
        && cd /jds \
        && git init \
        && git remote add -f origin https://github.com/Aaron-lv/someDockerfile \
        && git config core.sparsecheckout true \
        && echo jd_scripts >> /jds/.git/info/sparse-checkout \
        && git pull origin master --rebase

RUN cp /jds/jd_scripts/docker_entrypoint.sh /usr/local/bin \
        && chmod +x /usr/local/bin/docker_entrypoint.sh

WORKDIR /scripts

ENTRYPOINT ["docker_entrypoint.sh"]

CMD [ "crond" ]
