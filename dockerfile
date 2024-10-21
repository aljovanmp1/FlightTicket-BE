FROM elixir:alpine

RUN apk update && apk add inotify-tools
RUN apk add nano
RUN apk add --update alpine-sdk
RUN mkdir /app
WORKDIR /app
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile
COPY . .
COPY test_entrypoint.sh .
RUN chmod +x /app/test_entrypoint.sh

EXPOSE 4000
# CMD ["/app/entrypoint.sh"]
CMD ["mix", "phx.server"]