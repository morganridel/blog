# Blog

## Requirements

See `mise.toml`.

Outside of Elixir itself, I use tailwind for style, watchexec (via mise) for auto-rebuild and Caddy as a devserver.

## Installation

```
mise install
npm install
mix deps.get
```

## Development

To start the development server, which will watch for file changes and rebuild automatically, run:

```
mix run --no-halt
```

The server will be available at `http://localhost:4000`.

## Build

To build the static site for production, run:

```
mix build
```

The output will be in the `public` directory.

