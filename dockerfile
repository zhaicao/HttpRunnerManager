# this is dockerfile for httprunnermanager with python
FROM python:3.5-alpine

# maintainer
LABEL maintainer="Ricky <Ricky2971@hotmail.com>"

# add HttpRunnerManager
ADD HttpRunnerManager /opt/HttpRunnerManager

# expose port
EXPOSE 8000/tcp
EXPOSE 5555/tcp

# set WORKDIR
WORKDIR /opt/HttpRunnerManager

# set TZ
ENV TZ "Asia/Shanghai"

# set apk source
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories

# install dependences
RUN apk add --no-cache gcc g++ mysql-dev linux-headers libffi-dev openssl-dev libsodium build-base \
	&& pip install --upgrade pip \
	&& pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# replace testcase/response/context
ADD testcase.py /usr/local/lib/python3.5/site-packages/httprunner
ADD response.py /usr/local/lib/python3.5/site-packages/httprunner
ADD context.py /usr/local/lib/python3.5/site-packages/httprunner

# mountpoint
VOLUME /opt/HttpRunnerManager/reports/

ENTRYPOINT ["sh","start.sh"]