# LibreChat Development Guide

> Generated: 2026-02-23

## Prerequisites

- **Node.js**: v20.19.0+ or ^22.12.0 or >= 23.0.0
- **npm**: v11.10.0 (specified as packageManager)
- **MongoDB**: Required (local or Atlas)
- **Redis**: Optional but recommended for caching/sessions
- **MeiliSearch**: Optional for full-text search

## Environment Setup

1. Clone the repository
2. Copy `.env.example` to `.env` and configure:
   - MongoDB connection string
   - JWT secrets
   - AI provider API keys (OpenAI, Anthropic, Google, etc.)
   - Redis connection (optional)
   - MeiliSearch URL (optional)
3. Copy `librechat.example.yaml` to `librechat.yaml` for app configuration

## Installation

```bash
# Standard install + build via Turborepo
npm run smart-reinstall

# Clean install (wipes node_modules)
npm run reinstall

# Docker install
npm run reinstall:docker
```

## Development Commands

| Command | Purpose |
|---------|---------|
| `npm run backend:dev` | Start backend with file watching (port 3080) |
| `npm run frontend:dev` | Start frontend dev server with HMR (port 3090) |
| `npm run build` | Build all packages via Turborepo (parallel, cached) |
| `npm run build:data-provider` | Rebuild data-provider after changes |
| `npm run build:api` | Rebuild packages/api |
| `npm run build:data-schemas` | Rebuild data-schemas |
| `npm run build:packages` | Rebuild all packages in dependency order |

**Development workflow**: Run `npm run backend:dev` and `npm run frontend:dev` in separate terminals.

## Build System

**Turborepo** handles parallel, cached builds with dependency ordering:
- `packages/data-provider` builds first (shared by all)
- `packages/data-schemas` depends on data-provider
- `packages/api` depends on data-provider + data-schemas
- `client` depends on data-provider + packages/client

**Package bundling**: Rollup (data-provider, data-schemas, packages/api) with dual CJS/ESM output.
**Frontend bundling**: Vite 6 with React plugin, TailwindCSS, compression, PWA support.

## Testing

**Framework**: Jest (per-workspace)

```bash
# Backend tests
cd api && npx jest <pattern>
cd packages/api && npx jest <pattern>

# Frontend tests
cd client && npx jest <pattern>

# Data provider tests
cd packages/data-provider && npx jest <pattern>

# Data schemas tests
cd packages/data-schemas && npx jest <pattern>

# Integration tests (packages/api)
cd packages/api && npm run test:cache-integration
```

**Frontend testing**:
- `__tests__` directories alongside components
- Uses `@testing-library/react` + `@testing-library/jest-dom`
- Mock data-provider hooks and external dependencies
- Cover loading, success, and error states

**Backend testing**:
- Uses `supertest` for HTTP testing
- `mongodb-memory-server` for in-memory MongoDB

**E2E**: Playwright tests in `/e2e/`

## Code Style & Conventions

### TypeScript Rules
- **No `any` types** - explicit types for all parameters, return values, variables
- **Limit `unknown`** - avoid `Record<string, unknown>` and `as unknown as T`
- All new backend code must be TypeScript in `/packages/api`
- Keep `/api` changes minimal (thin JS wrappers)

### Import Order
1. Package imports (shortest to longest)
2. `import type` (longest to shortest, package types first)
3. Local imports (longest to shortest)

### Code Patterns
- **Never-nesting**: early returns, flat code
- **Functional first**: pure functions, map/filter/reduce over loops
- **Minimize looping**: single-pass transformations, Map/Set for lookups
- **Self-documenting code**: no inline comments narrating what code does

### Frontend-Specific
- All user-facing text: `useLocalize()` hook
- Only update English keys in `client/src/locales/en/translation.json`
- React Query for all API interactions
- QueryKeys in `packages/data-provider/src/keys.ts`

### Formatting
- Prettier: 100 char width, 2-space indent, single quotes, trailing commas
- ESLint: flat config in `eslint.config.mjs`
- TailwindCSS plugin for class sorting

## Docker Development

```bash
# Development stack (15 services)
docker compose -f docker-compose.dev.yml up -d

# Production stack
docker compose -f docker-compose.prod.yml up -d

# Deployed stack
npm run start:deployed
npm run stop:deployed
```

**Services include**: LibreChat API, MongoDB, Redis, MeiliSearch, RAG API, VectorDB, SearXNG, Firecrawl (with dedicated Redis), Code Interpreter

## User Management CLIs

```bash
npm run create-user       # Create user account
npm run invite-user       # Send invite
npm run list-users        # List all users
npm run ban-user          # Ban user
npm run delete-user       # Delete user
npm run add-balance       # Add token credits
npm run set-balance       # Set token balance
npm run list-balances     # List all balances
npm run reset-password    # Reset user password
```

## CI/CD Pipelines

13 GitHub Actions workflows:
- **Quality**: eslint-ci, backend-review, frontend-review, a11y, i18n-unused-keys, unused-packages
- **Testing**: cache-integration-tests
- **Docker**: dev-images, dev-branch-images, dev-staging-images, main-image-workflow, tag-images
- **Infrastructure**: helmcharts
