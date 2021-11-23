## BUILDER IMAGE
################
FROM node:lts-alpine as builder
ARG PKG=notset
WORKDIR /opt/cookbook

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


## DEPLOYABLE IMAGE
###################
FROM node:lts-alpine
ARG PKG=notset
WORKDIR /opt/cookbook

# Copy workspace package info
COPY package.json ./
COPY yarn.lock ./

# Copy shared and PKG package info and compiled dist from builder
COPY --from=builder /opt/cookbook/packages/shared/package.json ./packages/shared/package.json
COPY --from=builder /opt/cookbook/packages/shared/dist ./packages/shared/dist

COPY --from=builder /opt/cookbook/packages/$PKG/package.json ./packages/$PKG/package.json
COPY --from=builder /opt/cookbook/packages/$PKG/dist ./packages/$PKG/dist

# Install production only dependencies
ENV NODE_ENV production
RUN yarn install --pure-lockfile --non-interactive --production

# Run the PKG
WORKDIR /opt/cookbook/packages/$PKG
EXPOSE 8080
CMD yarn start
