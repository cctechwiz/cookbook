FROM node:lts-alpine

WORKDIR /opt/cookbook-api

# Install packages required by Shared and API workspaces
COPY package.json ./
COPY yarn.lock ./
COPY packages/shared/package.json ./packages/shared/
COPY packages/api/package.json ./packages/api/
RUN yarn install

# Copy Base, Shared, and API tsconfigs
COPY tsconfig.json ./
COPY packages/shared/tsconfig.json ./packages/shared/
COPY packages/api/tsconfig.json ./packages/api/

# Build Shared workspace
COPY packages/shared/src/ ./packages/shared/src/
RUN yarn @shared build

# Build API workspace
COPY packages/api/src/ ./packages/api/src/
RUN yarn @api build

# Run the API server on startup
EXPOSE 8080
CMD ["node", "packages/api/dist/server.js"]
