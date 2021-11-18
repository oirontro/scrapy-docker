FROM python:3.9

ENV TZ="Asia/Shanghai"

RUN sed -i "s@deb.debian.org@mirrors.aliyun.com@g" /etc/apt/sources.list \
    && sed -i "s@security.debian.org@mirrors.aliyun.com@g" /etc/apt/sources.list \
    && cat /etc/apt/sources.list \
    && mkdir ~/.pip \
    && bash -c 'echo -e "[global]\nindex-url = https://pypi.douban.com/simple/\n" > ~/.pip/pip.conf' \
    && cat ~/.pip/pip.conf

RUN apt-get update \
    && apt-get install -y sudo gosu \
    && gosu nobody true

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --default-timeout=1000 --no-cache-dir -r /tmp/requirements.txt

# Add local user 'dev'
RUN groupadd -r dev --gid=1000 && useradd -r -g dev --uid=1000 dev
# Grant him sudo privileges
RUN echo "dev ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev

COPY entrypoint.sh /entrypoint.sh
COPY dev_package.sh /dev_package.sh

RUN mkdir -p /app
WORKDIR /app

# Repass root
USER root

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "scrapy" ]
