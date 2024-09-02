# syntax=docker/dockerfile:1

FROM alpine:latest AS builder
RUN apk add --no-cache tzdata

FROM alpine:latest AS code
RUN apk add --no-cache wget unzip && \
    wget -O /tmp/code.zip https://github.com/ihmily/DouyinLiveRecorder/archive/refs/heads/main.zip && \
    unzip /tmp/code.zip -d /tmp && \
    mv /tmp/DouyinLiveRecorder-main /code && \
    rm /tmp/code.zip && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

FROM python:3.11-alpine AS final
WORKDIR /app
COPY --from=code /code .

RUN apk add --no-cache ffmpeg && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc /usr/share/licenses && \
    find /var/log -type f -delete

CMD ["python3", "main.py"]
