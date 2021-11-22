FROM node:lts-alpine

ARG PKG=notset

WORKDIR /opt/cookbook-$PKG

# Install packages required by Shared and PKG workspaces
COPY package.json ./
COPY yarn.lock ./
COPY packages/shared/package.json ./packages/shared/
COPY packages/$PKG/package.json ./packages/$PKG/
RUN yarn install

# Copy Base, Shared, and PKG tsconfigs
COPY tsconfig.json ./
COPY packages/shared/tsconfig.json ./packages/shared/
COPY packages/$PKG/tsconfig.json ./packages/$PKG/

# Build Shared workspace
COPY packages/shared/src/ ./packages/shared/src/
RUN yarn @shared build

# Build PKG workspace
COPY packages/$PKG/src/ ./packages/$PKG/src/
RUN yarn @$PKG build

# Run the PKG server on startup
EXPOSE 8080
CMD yarn @$PKG start
