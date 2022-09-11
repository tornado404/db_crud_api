FROM golang:1.17 AS building

COPY . /building
WORKDIR /building
RUN make all

FROM alpine:3.13

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk --update add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/shanghai" > /etc/timezone \
    && apk del tzdata

WORKDIR /home/paddleflow
COPY --from=building /building/output/bin/db-crud-api /home/paddleflow

RUN adduser -g paddleflow paddleflow -D && chown -R paddleflow:paddleflow /home/paddleflow/db-crud-api
USER paddleflow