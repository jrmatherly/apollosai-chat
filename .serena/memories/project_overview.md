# LibreChat - Project Overview

## Purpose
LibreChat is an open-source AI chat application (v0.8.3-rc1) that provides a unified interface for multiple AI providers. It's a full-stack web application with a React frontend and Node.js/Express backend, using MongoDB as its database.

## Tech Stack
- **Frontend**: React + TypeScript, Vite, TailwindCSS, React Query (@tanstack/react-query)
- **Backend**: Node.js + Express, legacy JS in `/api`, new TS code in `/packages/api`
- **Database**: MongoDB (Mongoose ODM)
- **Package Manager**: npm (v11.10.0)
- **Build System**: Turborepo for parallel cached builds
- **Testing**: Jest (per-workspace), Playwright (e2e)
- **Linting**: ESLint (flat config), Prettier
- **Node.js**: v20.19.0+ or ^22.12.0 or >= 23.0.0

## Architecture
Monorepo with npm workspaces:

| Workspace | Language | Purpose |
|---|---|---|
| `/api` | JavaScript (legacy) | Express server - minimize changes |
| `/packages/api` | TypeScript | New backend code (consumed by `/api`) |
| `/packages/data-schemas` | TypeScript | Database models/schemas |
| `/packages/data-provider` | TypeScript | Shared API types, endpoints, data-service (frontend + backend) |
| `/client` | TypeScript/React | Frontend SPA |
| `/packages/client` | TypeScript | Shared frontend utilities |

## Key Dependency
`@librechat/agents` - major backend dependency for agent/AI functionality.
