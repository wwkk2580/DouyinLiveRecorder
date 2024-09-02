# 使用更小的 Python 镜像
FROM python:3.11-slim-bullseye

WORKDIR /app

# 复制应用程序代码到工作目录
COPY . /app

# 更新并安装必要的依赖，同时清理缓存和临时文件
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg ffmpeg tzdata && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 设置启动命令
CMD ["python", "main.py"]
