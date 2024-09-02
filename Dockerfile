# syntax=docker/dockerfile:1

# 第一阶段：构建时区数据
FROM alpine:latest AS builder
RUN apk add --no-cache tzdata

# 第二阶段：下载代码并设置时区
FROM alpine:latest AS code
COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk add --no-cache wget unzip && \
    wget -O /tmp/code.zip https://github.com/ihmily/DouyinLiveRecorder/archive/refs/heads/main.zip && \
    unzip /tmp/code.zip -d /tmp && \
    mv /tmp/DouyinLiveRecorder-main /code && \
    rm -f /code/ffmpeg.exe && \
    rm /tmp/code.zip

# 第三阶段：安装Python和其他依赖
FROM python:3.11-alpine AS final
WORKDIR /app
COPY --from=code /code .

RUN apk add --no-cache ffmpeg && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc /usr/share/licenses && \
    find /var/log -type f -delete

CMD ["python3", "main.py"]
