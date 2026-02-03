# ----------- Builder -----------
FROM node:20-alpine AS builder

# Create app directory
WORKDIR /app

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install all dependencies (including devDependencies)
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build NestJS app
RUN pnpm run build


# ----------- runner -----------
FROM node:20-alpine AS runner

# Set NODE_ENV early
ENV NODE_ENV=production

# Create non-root user for security
RUN addgroup -S nodejs && adduser -S nestjs -G nodejs

# Create app directory
WORKDIR /app

# Enable pnpm (needed to prune deps)
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy built output from builder
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-lock.yaml ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/init_scripts ./init_scripts

# Remove devDependencies
RUN pnpm prune --prod

# Change ownership
RUN chown -R nestjs:nodejs /app

# Switch to non-root user
USER nestjs

# Expose app port
EXPOSE 3000

# Start the application
CMD ["node", "dist/main.js"]
