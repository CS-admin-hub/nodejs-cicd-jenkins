FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY src/ ./src/

# Expose port
EXPOSE 3000

# Set environment
ENV NODE_ENV=production
ENV APP_ENV=production

# Run application
CMD ["node", "src/index.js"]
