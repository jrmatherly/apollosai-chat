# LibreChat Integration Architecture

> Generated: 2026-02-23 | Repository Type: Monorepo

## Overview

LibreChat's monorepo parts communicate through clearly defined integration layers. The frontend never calls the backend directly — all communication flows through the shared `packages/data-provider`.

## Data Flow

```
┌─────────────┐     ┌──────────────────────────┐     ┌─────────────────────────────────┐
│   Frontend   │     │    Shared Packages         │     │           Backend                │
│   (client)   │     │                            │     │                                 │
│              │     │  data-provider              │     │  api/ (legacy JS)               │
│  Components ─┼──>──┤  ├─ api-endpoints.ts       │     │  ├─ server/routes/   ───────>───┤
│  + Hooks     │     │  ├─ data-service.ts  ──>───┼──>──┤  ├─ strategies/      (auth)     │
│              │     │  ├─ keys.ts (QueryKeys)    │     │  └─ models/          (wrappers) │
│  React Query─┼──<──┤  └─ react-query/           │     │                                 │
│  (caching)   │     │                            │     │  packages/api/ (new TS)         │
│              │     │  data-schemas               │     │  ├─ endpoints/                  │
│  Recoil/     │     │  ├─ schema/ (27 models)    │     │  ├─ agents/                     │
│  Jotai       │     │  ├─ models/                │     │  ├─ mcp/                        │
│  (UI state)  │     │  └─ types/           ──<───┼──<──┤  ├─ stream/                     │
│              │     │                            │     │  └─ cache/                      │
└─────────────┘     └──────────────────────────┘     └─────────────────────────────────┘
```

## Integration Points

### 1. Frontend → Backend (HTTP/REST)

| From | To | Protocol | Details |
|------|-----|----------|---------|
| React Query hooks | Express routes | HTTP REST | Via `data-service.ts` → Axios |
| SSE subscription | Agent streaming | Server-Sent Events | `/api/agents/chat/stream/:streamId` |
| File uploads | Multer handlers | HTTP multipart/form-data | `/api/files/` |

**Flow**: Component → custom hook → React Query → `data-service.ts` → Axios → Express route → handler → service → database

### 2. Shared Types (Compile-Time)

| From | To | Mechanism | Details |
|------|-----|-----------|---------|
| `data-provider/types/` | Frontend components | TypeScript imports | Shared interfaces and enums |
| `data-provider/types/` | Backend handlers | TypeScript imports | Same types ensure consistency |
| `data-schemas/types/` | Backend services | TypeScript imports | Model interfaces |
| `data-provider/schemas.ts` | Both sides | Zod schemas | Runtime validation |

### 3. Backend Internal (JS ↔ TS)

| From | To | Mechanism | Details |
|------|-----|-----------|---------|
| `api/server/routes/` (JS) | `packages/api/src/` (TS) | `require('@librechat/api')` | JS imports compiled TS |
| `api/models/` (JS) | `packages/data-schemas/` (TS) | `require('@librechat/data-schemas')` | Legacy wrappers |
| Route handlers | Mongoose models | `createModels(mongoose)` | Factory pattern |

### 4. Backend → External Services

| From | To | Protocol | Details |
|------|-----|----------|---------|
| AI handlers | OpenAI API | REST/SSE | GPT models, Assistants API |
| AI handlers | Anthropic API | REST/SSE | Claude models |
| AI handlers | Google GenAI | REST | Gemini models |
| AI handlers | AWS Bedrock | AWS SDK | Multi-model |
| AI handlers | Ollama | REST | Local models |
| MCP integration | MCP servers | MCP protocol | Tool execution |
| File handlers | S3/Azure Blob | AWS/Azure SDK | File storage |
| Search | MeiliSearch | REST | Full-text search |
| Cache/Sessions | Redis | ioredis | Caching + sessions |
| Auth | LDAP/SAML/OpenID | Various | Enterprise SSO |
| Graph API | Microsoft Graph | REST + OAuth OBO | SharePoint/OneDrive |

### 5. Frontend → Shared State

| Store Layer | Scope | Sync |
|-------------|-------|------|
| Recoil atoms | Global, in-memory | Within tab |
| Jotai atoms | Global, localStorage-persisted | Configurable (tab-isolated for MCP) |
| React Context | Feature/component tree | Within provider boundary |
| React Query cache | Server state mirror | Background refetch |

## Dependency Graph

```
@librechat/frontend (client)
├── librechat-data-provider
│   ├── axios, zod, dayjs
│   └── @tanstack/react-query (peer)
├── @librechat/client (packages/client)
│   └── librechat-data-provider
└── (all UI dependencies)

@librechat/backend (api)
├── @librechat/api (packages/api)
│   ├── librechat-data-provider
│   └── @librechat/data-schemas
├── @librechat/data-schemas (packages/data-schemas)
│   └── librechat-data-provider (peer)
├── librechat-data-provider
├── @librechat/agents (external)
└── (all backend dependencies)
```

## Build Dependency Order

```
1. packages/data-provider    (no internal deps)
2. packages/data-schemas     (depends on data-provider)
3. packages/api              (depends on data-provider + data-schemas)
4. packages/client           (depends on data-provider)
5. client                    (depends on data-provider + packages/client)
```

Managed by Turborepo with `dependsOn: ["^build"]` for automatic ordering.

## Key Integration Patterns

### Query Key Centralization
All React Query cache keys defined in `packages/data-provider/src/keys.ts`:
- `QueryKeys` for read operations
- `MutationKeys` for write operations
- Both frontend and backend reference these for consistency

### Endpoint URL Centralization
All API URLs defined in `packages/data-provider/src/api-endpoints.ts`:
- Used by `data-service.ts` for Axios calls
- Ensures URL consistency between frontend requests and backend routes

### Type Sharing
Types defined once in `packages/data-provider/src/types/`:
- Imported by frontend components for request/response typing
- Imported by backend handlers for the same types
- No duplication between frontend and backend type definitions

### Authentication Flow
```
Frontend login form
  → POST /api/auth/login
  → Passport local strategy → JWT generation
  → Tokens stored in httpOnly cookies
  → Subsequent requests include JWT
  → passport-jwt strategy validates
  → User object available in req.user
```

### Streaming Flow (Agent Chat)
```
Frontend sends POST to create generation job
  → Backend starts AI generation
  → Frontend subscribes to SSE at /api/agents/chat/stream/:streamId
  → Backend streams tokens via SSE
  → Frontend renders tokens in real-time
  → Stream ends → Frontend marks generation complete
```
