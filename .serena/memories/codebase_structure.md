# Codebase Structure

## Root
- `package.json` — Monorepo root, npm workspaces config
- `turbo.json` — Turborepo build pipeline config
- `eslint.config.mjs` — Flat ESLint config
- `.prettierrc` — Prettier formatting config
- `CLAUDE.md` — AI assistant instructions
- `librechat.example.yaml` — App configuration template
- `docker-compose.yml` — Docker setup

## `/api` (Legacy JS Backend)
- `api/server/` — Express server entry point
- `api/app/` — Application logic
- `api/models/` — Mongoose models (legacy)
- `api/strategies/` — Auth strategies
- `api/config/` — Backend configuration
- `api/cache/` — Caching logic
- `api/utils/` — Utilities

## `/packages/api/src` (New TS Backend)
- `endpoints/` — API route handlers
- `middleware/` — Express middleware
- `auth/` — Authentication logic
- `agents/` — AI agent logic
- `tools/` — AI tool definitions
- `mcp/` — MCP integration
- `files/` — File handling
- `db/` — Database operations
- `cache/` — Caching
- `stream/` — Streaming responses
- `oauth/` — OAuth flows
- `crypto/` — Encryption/crypto utilities
- `flow/` — Workflow/flow logic

## `/packages/data-provider/src` (Shared)
- `api-endpoints.ts` — API endpoint definitions
- `data-service.ts` — Data service layer
- `keys.ts` — QueryKeys and MutationKeys
- `types.ts` + `types/` — Shared type definitions
- `schemas.ts` — Validation schemas
- `config.ts` — Configuration types
- `react-query/` — React Query hooks

## `/packages/data-schemas/src` (Database)
- `models/` — Mongoose model definitions
- `schema/` — Schema definitions
- `methods/` — Model methods
- `types/` — Schema types

## `/client/src` (Frontend)
- `components/` — React components
- `hooks/` — Custom React hooks
- `data-provider/` — Feature-specific query hooks
- `store/` — State management
- `routes/` — Route definitions
- `Providers/` — React context providers
- `locales/` — i18n translations
- `utils/` — Frontend utilities
- `constants/` — Constants
- `common/` — Shared UI primitives
