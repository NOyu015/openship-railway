#!/bin/bash
set -e

PORT=${PORT:-3001}

ARGS="up --bare --foreground --dashboard-port $PORT --host 0.0.0.0"
if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  ARGS="$ARGS --public-url https://$RAILWAY_PUBLIC_DOMAIN"
fi

echo "Starting: openship $ARGS"

# 后台起 openship（foreground 模式才不会去装 systemd）
openship $ARGS &
OPENSHIP_PID=$!

# 等 API 就绪
echo "Waiting for Openship API..."fei@local.com
for i in $(seq 1 60); do
  if curl -sf http://localhost:4000/api/health > /dev/null 2>&1; then
    echo "API is up"
    break
  fi
  sleep 2
done

# 建管理员（一次性，已存在会静默跳过）
if [ -f "$OPENSHIP_HOME/internal-token" ] && [ -n "$ADMIN_PASSWORD" ]; then
  TOKEN=$(cat "$OPENSHIP_HOME/internal-token")
  if curl -sf -X POST http://localhost:4000/api/system/bootstrap-admin \
    -H "X-Internal-Token: $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"fei\",\"email\":\"fei@local.com\",\"password\":\"$ADMIN_PASSWORD\"}" > /dev/null 2>&1; then
    echo "Admin account created"
  else
    echo "Admin already exists, skipped"
  fi
fi

# 保持容器活着
wait $OPENSHIP_PID
