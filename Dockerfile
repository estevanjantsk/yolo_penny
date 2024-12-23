FROM elixir:1.16.3-otp-26-alpine

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  git \
  build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile

CMD ["mix", "phx.server"]
