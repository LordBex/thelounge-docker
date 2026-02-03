FROM node:22-alpine

ARG TARGETARCH
ARG THELOUNGE_VERSION=4.5.3-blowfish

LABEL org.opencontainers.image.title="Forked from 'The Lounge' image with Blowfish."
LABEL org.opencontainers.image.description="Forked of Docker image for The Lounge, a modern web IRC client with BlowFish designed for self-hosting."
LABEL org.opencontainers.image.authors="The Lounge #thelounge @irc.libera.chat"
LABEL org.opencontainers.image.url="https://github.com/LordBex/thelounge-docker"
LABEL org.opencontainers.image.source="https://github.com/LordBex/thelounge-docker"
LABEL org.opencontainers.image.version="${THELOUNGE_VERSION}"
LABEL org.opencontainers.image.licenses="MIT"

EXPOSE 9000

ENV THELOUNGE_HOME="/var/opt/thelounge"
ENV NODE_ENV=production

# ENV npm_config_arch=$TARGETARCH
RUN apk --update --no-cache --virtual build-deps add python3 py3-setuptools build-base git \
  && ln -sf python3 /usr/bin/python \
  && yarn --non-interactive --frozen-lockfile global add @lordbex/thelounge@${THELOUNGE_VERSION} \
  && yarn --non-interactive cache clean \
  && apk del --purge build-deps \
  && rm -rf /root/.cache /tmp /usr/bin/python

RUN install -d -o node -g node "${THELOUNGE_HOME}"
# order of the directives matters, keep VOLUME below the dir creation
VOLUME "${THELOUNGE_HOME}"

USER node:node
ENTRYPOINT ["/usr/local/bin/thelounge"]
CMD ["start"]
