FROM node:22-slim

# openship CLI（自托管部署平台，一键构建发布）
RUN npm i -g openship@0.8.2

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 数据目录挂 Railway Volume，保证重启不丢
ENV OPENSHIP_HOME=/data/.openship

EXPOSE 3001

CMD ["/app/start.sh"]
