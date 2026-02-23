# Suggested Commands

## Development
- `npm run backend:dev` — Start backend with file watching (dev mode)
- `npm run frontend:dev` — Start frontend dev server with HMR (port 3090, requires backend)
- `npm run backend` — Start backend in production mode (port 3080)

## Building
- `npm run build` — Build all packages via Turborepo (parallel, cached)
- `npm run build:data-provider` — Rebuild data-provider after changes
- `npm run build:api` — Rebuild packages/api
- `npm run build:data-schemas` — Rebuild data-schemas
- `npm run build:packages` — Build all packages sequentially
- `npm run frontend` — Build everything sequentially (legacy fallback)

## Dependencies
- `npm run smart-reinstall` — Install deps (if lockfile changed) + build via Turborepo
- `npm run reinstall` — Clean install (wipe node_modules, reinstall from scratch)

## Testing
- `cd api && npx jest <pattern>` — Run backend tests
- `cd packages/api && npx jest <pattern>` — Run packages/api tests
- `cd client && npx jest <pattern>` — Run frontend tests
- `npm run e2e` — Run Playwright e2e tests
- `npm run e2e:headed` — Run e2e tests with browser visible

## Linting
- ESLint flat config at `eslint.config.mjs`
- Run via: `npx eslint <path>`

## Utility (macOS/Darwin)
- `git` — Version control
- `ls`, `find`, `grep` — File operations (standard macOS)
