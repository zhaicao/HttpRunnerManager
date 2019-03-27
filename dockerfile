# this is dockerfile for httprunnermanager with python
FROM python:3.5-alpine

# maintainer
LABEL maintainer="Ricky <Ricky2971@hotmail.com>"

# add HttpRunnerManager
ADD HttpRunnerManager /opt/HttpRunnerManage

# expose port
EXPOSE 8000

# set WORKDIR
WORKDIR /opt/HttpRunnerManage

ENV TZ "Asia/Shanghai"

# install dependences
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories \
    && apk add --no-cache gcc g++ mysql-dev linux-headers libffi-dev openssl-dev libsodium build-base \
	&& pip install --upgrade pip \
	&& pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# mountpoint
VOLUME /opt/HttpRunnerManager/reports/

ENTRYPOINT ["sh","start.sh"]