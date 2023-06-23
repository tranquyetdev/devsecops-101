# @see https://github.com/vercel/next.js/blob/canary/examples/with-docker/Dockerfile

FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# @see https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine
RUN apk add --no-cache libc6-compat
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Builder stage
# FROM base AS builder
# WORKDIR /app

# COPY --from=deps /app/node_modules ./node_modules
# COPY . .

# # Disable telemetry
# ENV NEXT_TELEMETRY_DISABLED 1

# # Run the build target here for consistency instead of inside Github Actions
# RUN npx nx build simple-nextjs-app --prod

# This assumes that the project was built using `nx build simple-nextjs-app --prod`
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

RUN chown -R nextjs:nodejs .

# Try standalone build but it doesn't work yet
# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
# COPY --from=builder /app/dist/apps/simple-nextjs-app/public ./public
# COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
# COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Try standalone in a different way but it doesn't work yet
# COPY dist/apps/simple-nextjs-app/.next/standalone/dist/apps/simple-nextjs-app/.next ./.next
# COPY dist/apps/simple-nextjs-app/.next/standalone/node_modules ./node_modules
# COPY dist/apps/simple-nextjs-app/package.json ./package.json
# COPY dist/apps/simple-nextjs-app/.next/static ./.next/static
# COPY dist/apps/simple-nextjs-app/.next/standalone/apps/simple-nextjs-app/server.js ./server.js
# COPY dist/apps/simple-nextjs-app/public ./public

COPY --from=deps /app/node_modules ./node_modules
COPY dist/apps/simple-nextjs-app .

# RUN ls -lsa

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD [ "yarn", "start"]
