# this is dockerfile for httprunnermanager with python
FROM python:3.5-alpine
LABEL maintainer="zhaicao <Ricky2971@hotmail.com>"
# add HttpRunnerManager
ADD HttpRunnerManager /opt/HttpRunnerManager

EXPOSE 8000/tcp
EXPOSE 5555/tcp

WORKDIR /opt/HttpRunnerManager
ENV TZ "Asia/Shanghai"
# set apk source
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories \
        && apk add --no-cache gcc g++ mysql-dev linux-headers libffi-dev openssl-dev libsodium build-base tzdata \
	&& pip install --upgrade pip \
	&& pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# replace testcase/response/context
ADD testcase.py /usr/local/lib/python3.5/site-packages/httprunner
ADD response.py /usr/local/lib/python3.5/site-packages/httprunner
ADD context.py /usr/local/lib/python3.5/site-packages/httprunner

ENTRYPOINT ["sh","start.sh"]
