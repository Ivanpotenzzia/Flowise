# Build local monorepo image
# docker build --no-cache -t  flowise .

# Run image
# docker run -d -p 3000:3000 flowise

FROM node:20-alpine
RUN apk add --update libc6-compat python3 make g++
# needed for pdfjs-dist
RUN apk add --no-cache build-base cairo-dev pango-dev

# Install Chromium
RUN apk add --no-cache chromium

# Install PNPM globally
RUN npm install -g pnpm@10.26.0 --force

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

ENV NODE_OPTIONS=--max-old-space-size=8192

WORKDIR /usr/src

# Copy app source
COPY . .

RUN npx --yes pnpm@10.26.0 --version
RUN npx --yes pnpm@10.26.0 install

RUN npx --yes pnpm@10.26.0 build

EXPOSE 3000

CMD [ "pnpm", "start" ]
