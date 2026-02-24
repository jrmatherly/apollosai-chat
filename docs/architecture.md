# LibreChat Architecture

> Generated: 2026-02-23 | Version: v0.8.3-rc1

## Executive Summary

LibreChat is an open-source AI chat application providing a unified interface for multiple AI providers. Built as a monorepo with npm workspaces and Turborepo, it features a React SPA frontend, Node.js/Express backend, and MongoDB persistence with Redis caching and MeiliSearch for full-text search.

## Repository Structure

**Type**: Monorepo (npm workspaces + Turborepo)
**Parts**: 3 logical groups (frontend, backend, shared)

| Part | Workspaces | Type | Primary Tech |
|------|------------|------|-------------|
| Frontend | `client/` | Web SPA | React 18, TypeScript, Vite 6, TailwindCSS |
| Backend | `api/`, `packages/api/` | API Server | Node.js, Express 5, TypeScript, MongoDB |
| Shared | `packages/data-provider/`, `packages/data-schemas/`, `packages/client/` | Libraries | TypeScript, Zod, Mongoose, React Query |

## Technology Stack

### Frontend
| Category | Technology | Version |
|----------|-----------|---------|
| Framework | React | 18.2 |
| Language | TypeScript | 5.3 |
| Build | Vite | 6.4 |
| Styling | TailwindCSS | 3.4 |
| Server State | React Query | 4.28 |
| Client State | Recoil + Jotai | 0.7.7 / 2.12 |
| Routing | React Router DOM | 6.30 |
| UI Primitives | Radix UI | various |
| i18n | react-i18next | 15.4 |
| Markdown | react-markdown + rehype/remark | various |

### Backend
| Category | Technology | Version |
|----------|-----------|---------|
| Runtime | Node.js | 20+ |
| Framework | Express | 5.2 |
| Database | MongoDB (Mongoose) | 8.12 |
| Search | MeiliSearch | 0.38 |
| Cache/Sessions | Redis (ioredis) | 5.3 |
| Auth | Passport (13 strategies) | 0.6 |
| AI Integration | OpenAI, Anthropic, Google GenAI, AWS Bedrock | various |
| Agent Framework | @librechat/agents | 3.1.51 |
| MCP | @modelcontextprotocol/sdk | 1.26 |
| Logging | Winston | 3.11 |

## Architecture Patterns

### Frontend: Component-Based SPA
```
React Router (routes) → Page Components → Feature Components
                                              │
                         ┌────────────────────┼────────────────────┐
                         │                    │                    │
                    Recoil/Jotai         React Context       React Query
                   (global state)     (feature-scoped)    (server state)
                         │                    │                    │
                         └────────────────────┼────────────────────┘
                                              │
                                    Custom Hooks (50+ categories)
                                              │
                                    data-provider (Axios → API)
```

- **630+ components** across 24 directories
- **4-tier state management**: Recoil (global) → Jotai (persisted) → Context (scoped) → React Query (server)
- **28 context providers** for feature encapsulation
- **Tab-isolated storage** for MCP and new chat conversations

### Backend: Express Middleware Pipeline
```
HTTP Request → Express Router → Auth Middleware → Rate Limiter → Route Handler
                                                                      │
                                                                 Service Layer
                                                                      │
                                                          ┌───────────┼───────────┐
                                                          │           │           │
                                                     Mongoose      Redis      MeiliSearch
                                                     (MongoDB)    (Cache)     (Search)
```

- **Legacy JS** (`/api`) wraps **new TypeScript** (`/packages/api`)
- **100+ API endpoints** across 20+ feature areas
- **13 Passport auth strategies** (local, JWT, OAuth, LDAP, SAML, OpenID)
- **SSE streaming** for real-time AI responses
- **OpenAI-compatible API** at `/api/agents/v1/chat/completions`

### Shared: Library Pattern
```
packages/data-provider          packages/data-schemas
├── api-endpoints.ts            ├── schema/ (27 models)
├── data-service.ts             ├── models/ (factory functions)
├── keys.ts (QueryKeys)         ├── methods/ (custom methods)
├── types/ (shared types)       └── types/ (TypeScript interfaces)
└── react-query/ (hooks)
```

- **Dual CJS/ESM exports** for universal consumption
- **Zod validation** for runtime type safety
- **27 Mongoose models** via `createModels()` factory
- **React Query hooks** for frontend data fetching

## Data Architecture

### Database: MongoDB (27 collections)

**Core Domain**: User, Session, Token, Conversation, Message, ConversationTag, ToolCall
**AI Features**: Agent, Assistant, AgentCategory, AgentApiKey, Prompt, PromptGroup
**Access Control**: Role, AccessRole, ACLEntry, Group
**Files & Content**: File, SharedLink, Action, PluginAuth, MCPServer
**Business**: Balance, Transaction, MemoryEntry, Project, Banner, Preset, Key

### Key Design Patterns
- **TTL Indexes** for auto-expiring sessions, tokens, files
- **MeiliSearch sync** via `_meiliIndex` field for full-text search
- **Composite unique indexes** (conversationId+user, tag+user)
- **Bitwise permission flags** in ACL entries
- **Conversation preset inheritance** (40+ config fields shared between Conversation and Preset)

### Caching: Redis
- Session storage via `connect-redis`
- Rate limiting via `rate-limit-redis`
- General caching via `keyv` + `@keyv/redis`
- MCP server state management

## Authentication Architecture

13 Passport strategies supporting:
- **Local**: Username/password with bcrypt
- **JWT**: Token-based authentication with refresh flow
- **2FA**: TOTP with backup codes
- **OAuth**: Google, GitHub, Discord, Facebook, Apple
- **Enterprise**: LDAP, SAML, OpenID Connect
- **Graph API**: SharePoint/OneDrive integration via OBO token exchange

## AI Integration Architecture

### Multi-Provider Support
- **OpenAI** (GPT models, Assistants API v1/v2)
- **Anthropic** (Claude models, Vertex AI)
- **Google** (GenAI SDK)
- **AWS Bedrock** (multi-model)
- **Ollama** (local models)

### Agent Framework
- **@librechat/agents** (v3.1.51) for agent orchestration
- **Composite agents** with graph-based edges for chaining
- **Tool integration**: MCP tools, custom tools, code execution, file search, web search
- **Streaming**: Server-Sent Events for real-time generation

### MCP (Model Context Protocol)
- **@modelcontextprotocol/sdk** for tool server integration
- User-configurable MCP servers with OAuth support
- Per-conversation MCP tool state management
- Tab-isolated state for multi-tab usage

## Deployment Architecture

### Docker Stack (15 services in dev)
- **LibreChat API** (Node.js)
- **MongoDB** (primary database)
- **Redis** (caching, sessions) with allkeys-lru eviction
- **Firecrawl Redis** (dedicated, noeviction policy)
- **MeiliSearch** (full-text search)
- **RAG API** (retrieval augmented generation)
- **VectorDB** (vector embeddings)
- **SearXNG** (web search proxy)
- **Firecrawl** (web scraping)
- **Code Interpreter** (sandboxed Python execution with seccomp)

### Kubernetes
- Helm charts for LibreChat and RAG API
- DNS configuration support
- Environment variable management

### CI/CD
- 13 GitHub Actions workflows
- Quality gates: ESLint, backend/frontend review, a11y, i18n unused keys
- Docker image builds: dev, staging, main, tag-based
- Integration tests for cache layer

## Security

- **JWT** with refresh token rotation
- **2FA** (TOTP + backup codes)
- **MongoDB sanitization** (`express-mongo-sanitize`)
- **Rate limiting** on sensitive endpoints
- **RBAC** with fine-grained permissions (8+ permission types)
- **ACL** with bitwise permission flags for resource-level access
- **Seccomp sandboxing** for code execution containers
- **jemalloc** memory allocator for production
