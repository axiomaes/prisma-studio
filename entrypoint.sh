#!/usr/bin/env bash
set -euo pipefail

mkdir -p /app/prisma

# Si no existe schema, creamos uno mínimo
if [ ! -f /app/prisma/schema.prisma ]; then
  cat > /app/prisma/schema.prisma <<'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
EOF
fi

# Comprobamos DATABASE_URL
if [ -z "${DATABASE_URL:-}" ]; then
  echo "ERROR: DATABASE_URL no está definido" >&2
  exit 1
fi

# Trae el esquema real de la DB
echo "[prisma] Ejecutando db pull..."
prisma db pull --schema=/app/prisma/schema.prisma

echo "[prisma] schema.prisma generado en /app/prisma/schema.prisma"

# Levanta Prisma Studio
# Levanta Prisma Studio
exec prisma studio \
  --schema=/app/prisma/schema.prisma \
  --port 5555 \
  --hostname 0.0.0.0 \
  --browser none
