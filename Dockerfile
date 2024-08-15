# syntax=docker/dockerfile:1
# 第一阶段：从 tzdata 获取 Asia/Shanghai 时区文件
FROM alpine:latest AS builder
RUN apk add --no-cache tzdata

# 第二阶段：下载并准备代码
FROM alpine:latest AS code
COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apk add --no-cache wget unzip && \
    wget -O /tmp/code.zip https://github.com/ihmily/DouyinLiveRecorder/archive/refs/heads/main.zip && \
    unzip /tmp/code.zip -d /tmp && \
    mv /tmp/DouyinLiveRecorder-main /code && \
    rm -f /code/ffmpeg.exe && \
    rm /tmp/code.zip

# 第三阶段：设置应用环境并运行
FROM alpine:latest
WORKDIR /app
COPY --from=code /code .

# 安装必要的包并清理不需要的文件
RUN apk add --no-cache ffmpeg py3-pip python3 && \
    pip3 install --no-cache-dir -r requirements.txt && \
    # 清理不必要的文件和目录
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc /usr/share/licenses && \
    # 清理日志文件
    find /var/log -type f -delete

CMD ["python3", "main.py"]
