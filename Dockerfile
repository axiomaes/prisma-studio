# prisma-studio sidecar (Alpine)
FROM node:20-alpine

# Dependencias habituales para Prisma en Alpine
RUN apk add --no-cache openssl bash libc6-compat

ENV PRISMA_HIDE_UPDATE_MESSAGE=1 \
    npm_config_update_notifier=false

# CLI Prisma
RUN npm i -g prisma@5

WORKDIR /app
EXPOSE 5555

# Copiamos entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
