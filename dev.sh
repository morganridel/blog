set -e

mise watch build \
  --watch content \
  --watch assets \
  --watch lib & caddy run
