# 使用更小的基础镜像
FROM python:3.11-alpine AS base

WORKDIR /app

# 复制应用程序代码
COPY . /app

# 安装必要的依赖项和时区数据
RUN apk add --no-cache --update tzdata ffmpeg curl nodejs npm && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    pip install --no-cache-dir -r requirements.txt
    
# 设置启动命令
CMD ["python", "main.py"]
