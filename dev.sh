set -e

mise watch build \
  --watch content \
  --watch assets \
  --watch priv/templates & caddy run
