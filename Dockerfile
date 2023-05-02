# build front-end
# 注: 修改后的docker镜像会更大一些, 因为包含了npm各种包.
# 修改0
# FROM node:lts-alpine AS frontend
FROM node:lts-alpine

RUN npm install pnpm -g

WORKDIR /data/front

COPY ./package.json /data/front

COPY ./pnpm-lock.yaml /data/front

RUN pnpm install

COPY . /data/front

RUN pnpm run build

# build backend
# FROM node:lts-alpine as backend

# RUN npm install pnpm -g

WORKDIR /data/back

COPY /service/package.json /data/back

COPY /service/pnpm-lock.yaml /data/back

RUN pnpm install

COPY /service /data/back

RUN pnpm build

# service
# FROM node:lts-alpine

# RUN npm install pnpm -g

WORKDIR /app

COPY /service/package.json /app

COPY /service/pnpm-lock.yaml /app

RUN pnpm install --production && rm -rf /root/.npm /root/.pnpm-store /usr/local/share/.cache /tmp/*

COPY /service /app

# COPY --from=frontend /data/front/dist /app/public

# COPY --from=frontend /data/back/build /app/build

# 修改1
RUN cp -r /data/front/dist /app/public
# 修改2
RUN cp -r /data/back/build /app/build

EXPOSE 3002

CMD ["pnpm", "run", "prod"]
