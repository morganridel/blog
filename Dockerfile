# Build stage
FROM hexpm/elixir:1.19.4-erlang-28.0-alpine-3.23.0 AS builder

# Install build dependencies
RUN apk add --update nodejs npm

WORKDIR /app

# Copy mix files
COPY mix.exs mix.lock ./


# Copy source code
COPY . .

RUN npm install
ENV MIX_ENV=prod
RUN mix deps.get --only prod
RUN mix build

# The image will probably be built as root, but the user in the NGINX image is not root
# This could be solved in cleaner way later but for now we let "other" read all files
RUN chmod -R 755 /app/public


FROM nginx:alpine

# Copy the built site from builder
COPY --from=builder /app/public /usr/share/nginx/html