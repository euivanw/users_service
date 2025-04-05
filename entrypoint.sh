#!/bin/sh
exec /app/bin/server \
  --define=SERVER_PORT="${SERVER_PORT}" \
  --define=DB_HOST="${DB_HOST}" \
  --define=DB_PORT="${DB_PORT}" \
  --define=DB_USER="${DB_USER}" \
  --define=DB_PASSWORD="${DB_PASSWORD}" \
  --define=DB_DATABASE="${DB_DATABASE}"
