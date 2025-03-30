# 1️⃣ Use a lightweight Node.js image for building
FROM node:20-alpine AS builder

# 2️⃣ Set the working directory
WORKDIR /app

# 3️⃣ Copy package.json and pnpm-lock.yaml to install dependencies first
COPY package.json pnpm-lock.yaml ./

# 4️⃣ Enable pnpm and install dependencies
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN pnpm install --frozen-lockfile

# 5️⃣ Copy the entire source code
COPY . .

# 6️⃣ Build the Next.js project
RUN pnpm build

# 7️⃣ Use a separate lightweight image for running the app
FROM node:20-alpine AS runner
WORKDIR /app

# 8️⃣ Copy necessary files from the builder stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# 9️⃣ Expose the application port
EXPOSE 3000

# 🔟 Run the Next.js app
CMD ["node", ".next/standalone/server.js"]