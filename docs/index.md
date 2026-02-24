# LibreChat Documentation Index

> Generated: 2026-02-23 | Version: v0.8.3-rc1 | Scan Level: Deep

## Project Overview

- **Type:** Monorepo (npm workspaces + Turborepo) with 3 logical parts
- **Primary Language:** TypeScript
- **Architecture:** Component-based SPA frontend + Express middleware pipeline backend
- **Database:** MongoDB (27 Mongoose models) + Redis cache + MeiliSearch

## Quick Reference

### Frontend (`client/`)
- **Type:** Web SPA
- **Tech Stack:** React 18, TypeScript 5, Vite 6, TailwindCSS 3, React Query 4, Radix UI
- **Components:** 630+ across 24 directories
- **State:** Recoil + Jotai + 28 Context Providers + React Query
- **Entry Point:** `client/vite.config.ts`

### Backend (`api/` + `packages/api/`)
- **Type:** API Server
- **Tech Stack:** Node.js 20+, Express 5, TypeScript, MongoDB/Mongoose 8, Redis, 13 Passport strategies
- **Endpoints:** 100+ REST API endpoints across 20+ feature areas
- **AI Providers:** OpenAI, Anthropic, Google GenAI, AWS Bedrock, Ollama
- **Entry Point:** `api/server/index.js`

### Shared (`packages/data-provider/` + `packages/data-schemas/` + `packages/client/`)
- **Type:** Shared Libraries
- **Tech Stack:** TypeScript 5, Zod, Mongoose, Axios, React Query hooks
- **Models:** 27 database models via `createModels()` factory
- **Build:** Rollup with dual CJS/ESM output

## Generated Documentation

- [Project Overview](./project-overview.md) - Executive summary, features, workspace map
- [Architecture](./architecture.md) - Full architecture documentation, tech stack, patterns
- [Source Tree Analysis](./source-tree-analysis.md) - Annotated directory structure
- [Integration Architecture](./integration-architecture.md) - How parts communicate, data flow, dependency graph
- [API Contracts](./api-contracts.md) - All 100+ REST API endpoints by feature area
- [Data Models](./data-models.md) - 27 Mongoose models with schemas and indexes
- [Component Inventory](./component-inventory.md) - 630+ UI components, state management, hooks
- [Development Guide](./development-guide.md) - Setup, commands, testing, conventions

## Existing Documentation

- [README.md](../README.md) - Project readme with branding and getting started
- [AGENTS.md](../AGENTS.md) - Monorepo architecture guide and workspace boundaries
- [CHANGELOG.md](../CHANGELOG.md) - Detailed changelog of all releases
- [CLAUDE.md](../CLAUDE.md) - AI development instructions and code style
- [.github/CONTRIBUTING.md](../.github/CONTRIBUTING.md) - Contributor guidelines
- [.github/SECURITY.md](../.github/SECURITY.md) - Security vulnerability reporting
- [packages/data-schemas/README.md](../packages/data-schemas/README.md) - Data schemas package docs
- [helm/librechat/readme.md](../helm/librechat/readme.md) - Kubernetes Helm chart docs
- [redis-config/README.md](../redis-config/README.md) - Redis configuration guide

## Getting Started

1. **Prerequisites**: Node.js v20.19.0+, MongoDB, optional Redis + MeiliSearch
2. **Install**: `npm run smart-reinstall`
3. **Configure**: Copy `.env.example` → `.env`, `librechat.example.yaml` → `librechat.yaml`
4. **Develop**: `npm run backend:dev` + `npm run frontend:dev` (ports 3080/3090)
5. **Build**: `npm run build` (Turborepo parallel cached build)
6. **Test**: `cd <workspace> && npx jest <pattern>`
7. **Docker**: `docker compose -f docker-compose.dev.yml up -d`
