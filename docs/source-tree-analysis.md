# LibreChat Source Tree Analysis

> Generated: 2026-02-23 | Repository Type: Monorepo (npm workspaces + Turborepo)

## Project Root

```
LibreChat/                          # Monorepo root (v0.8.3-rc1)
├── api/                            # [BACKEND] Legacy Express server (JavaScript)
│   ├── server/
│   │   ├── index.js                # ** ENTRY POINT ** Express app bootstrap
│   │   ├── routes/                 # HTTP route handlers
│   │   │   ├── index.js            # Route aggregator
│   │   │   ├── auth.js             # Auth: login, register, 2FA, refresh
│   │   │   ├── convos.js           # Conversations CRUD
│   │   │   ├── messages.js         # Messages CRUD + feedback
│   │   │   ├── agents/             # Agent routes (CRUD, streaming, OpenAI-compat)
│   │   │   │   ├── index.js        # Agent management
│   │   │   │   ├── openai.js       # /v1/chat/completions (OpenAI-compatible)
│   │   │   │   └── responses.js    # Open Responses API
│   │   │   ├── assistants/         # Assistant routes (v1 + v2)
│   │   │   ├── files/              # File upload, images, speech (STT/TTS)
│   │   │   ├── mcp.js              # MCP server management + OAuth
│   │   │   ├── prompts.js          # Prompts & prompt groups
│   │   │   ├── roles.js            # RBAC role management
│   │   │   ├── accessPermissions.js # Granular ACL
│   │   │   ├── share.js            # Shared links
│   │   │   ├── tags.js             # Conversation tags
│   │   │   ├── memories.js         # User memories
│   │   │   └── ...                 # presets, keys, balance, search, config, etc.
│   │   ├── middleware/             # Express middleware
│   │   ├── services/               # Business logic services
│   │   │   ├── Config/             # App configuration
│   │   │   ├── start/              # Startup: migrations, seed, init
│   │   │   └── ...
│   │   ├── socialLogins.js         # Social login configuration
│   │   └── utils/                  # Backend utilities
│   ├── strategies/                 # Passport auth strategies (13)
│   │   ├── localStrategy.js        # Username/password
│   │   ├── jwtStrategy.js          # JWT token
│   │   ├── openidStrategy.js       # OpenID Connect
│   │   ├── samlStrategy.js         # SAML SSO
│   │   ├── ldapStrategy.js         # LDAP directory
│   │   ├── googleStrategy.js       # Google OAuth
│   │   ├── githubStrategy.js       # GitHub OAuth
│   │   ├── discordStrategy.js      # Discord OAuth
│   │   ├── facebookStrategy.js     # Facebook OAuth
│   │   ├── appleStrategy.js        # Apple OAuth
│   │   └── socialLogin.js          # Social login handler
│   ├── models/                     # Legacy model wrappers (JS → packages/data-schemas)
│   ├── cache/                      # Redis caching logic
│   ├── config/                     # Backend configuration
│   └── utils/                      # Shared utilities
│
├── packages/
│   ├── api/                        # [BACKEND] New TypeScript backend
│   │   └── src/
│   │       ├── endpoints/          # API route handlers (TS)
│   │       ├── middleware/         # Express middleware (TS)
│   │       ├── auth/              # Authentication logic
│   │       ├── agents/            # AI agent logic
│   │       ├── tools/             # AI tool definitions
│   │       ├── mcp/               # MCP integration
│   │       ├── files/             # File handling
│   │       ├── db/                # Database operations
│   │       ├── cache/             # Redis caching (TS)
│   │       ├── stream/            # SSE streaming responses
│   │       ├── oauth/             # OAuth flows
│   │       ├── crypto/            # Encryption utilities
│   │       ├── flow/              # Workflow logic
│   │       └── cluster/           # Redis cluster support
│   │
│   ├── data-provider/              # [SHARED] API types, endpoints, data-service
│   │   └── src/
│   │       ├── api-endpoints.ts    # ** API URL definitions **
│   │       ├── data-service.ts     # ** Data service layer **
│   │       ├── keys.ts             # ** QueryKeys + MutationKeys **
│   │       ├── types.ts            # Shared type re-exports
│   │       ├── types/              # Type definitions
│   │       │   ├── queries.ts      # React Query types
│   │       │   ├── assistants.ts   # Assistant types
│   │       │   ├── agents.ts       # Agent types
│   │       │   ├── files.ts        # File types
│   │       │   └── ...
│   │       ├── schemas.ts          # Zod validation schemas
│   │       ├── config.ts           # Config types
│   │       ├── roles.ts            # Permission constants
│   │       └── react-query/        # Shared React Query hooks
│   │
│   ├── data-schemas/               # [SHARED] Mongoose models & schemas
│   │   └── src/
│   │       ├── schema/             # Schema definitions (27 models)
│   │       ├── models/             # Model factory functions
│   │       │   └── index.ts        # createModels(mongoose) aggregator
│   │       ├── methods/            # Custom model methods
│   │       └── types/              # TypeScript interfaces
│   │
│   └── client/                     # [SHARED] Frontend utilities
│       └── src/
│           └── theme/              # Dynamic theming system
│
├── client/                         # [FRONTEND] React SPA
│   ├── src/
│   │   ├── components/             # React components (630+)
│   │   │   ├── Chat/               # Chat view, input, messages (120+)
│   │   │   ├── SidePanel/          # Right sidebar: agents, MCP, files (140+)
│   │   │   ├── Nav/                # Navigation, settings (100+)
│   │   │   ├── Agents/             # Agent marketplace (23)
│   │   │   ├── Auth/               # Authentication forms (17)
│   │   │   ├── Prompts/            # Prompt management (37)
│   │   │   ├── Artifacts/          # Artifact viewer (10)
│   │   │   ├── Messages/           # Message rendering (40+)
│   │   │   ├── Files/              # File management (30+)
│   │   │   └── ...                 # Endpoints, Bookmarks, Share, Web, MCP, etc.
│   │   ├── hooks/                  # Custom React hooks (50+ categories)
│   │   ├── store/                  # State management (Recoil + Jotai, 22 files)
│   │   ├── Providers/              # React context providers (28)
│   │   ├── data-provider/          # React Query hooks (11 feature areas)
│   │   ├── routes/                 # React Router route definitions
│   │   ├── locales/                # i18n translations (41 languages)
│   │   ├── utils/                  # Frontend utilities
│   │   ├── constants/              # Constants
│   │   └── common/                 # Shared UI types and primitives
│   └── vite.config.ts              # Vite build configuration
│
├── config/                         # Build/deploy scripts, user management CLIs
├── docker-compose.yml              # Standard Docker Compose
├── docker-compose.dev.yml          # Development stack (15 services)
├── docker-compose.prod.yml         # Production stack
├── deploy-compose.yml              # Deployment composition
├── Dockerfile                      # Node 20 Alpine + jemalloc + uv
├── Dockerfile.multi                # Multi-stage build
│
├── .github/
│   ├── workflows/                  # CI/CD (13 workflows)
│   │   ├── eslint-ci.yml           # Linting
│   │   ├── backend-review.yml      # Backend tests
│   │   ├── frontend-review.yml     # Frontend tests
│   │   ├── cache-integration-tests.yml # Integration tests
│   │   ├── main-image-workflow.yml # Docker image build
│   │   └── ...
│   ├── CONTRIBUTING.md
│   └── SECURITY.md
│
├── helm/                           # Kubernetes Helm charts
│   ├── librechat/                  # Main chart
│   └── librechat-rag-api/          # RAG API chart
│
├── redis-config/                   # Redis configuration (cluster + TLS)
├── searxng/                        # SearXNG web search config
├── code-interpreter/               # Code execution sandbox (seccomp profile)
├── e2e/                            # Playwright end-to-end tests
│
├── turbo.json                      # Turborepo pipeline config
├── package.json                    # Monorepo root + workspace definitions
├── eslint.config.mjs               # ESLint flat config
├── CLAUDE.md                       # AI development instructions
└── AGENTS.md                       # Architecture guide
```

## Critical Directories by Part

### Frontend (`client/`)
| Directory | Purpose |
|-----------|---------|
| `src/components/Chat/` | Primary chat interface, input, message rendering |
| `src/components/SidePanel/` | Agent builder, MCP builder, file browser, memories |
| `src/components/Nav/` | Navigation, settings tabs, user menu |
| `src/store/` | Recoil + Jotai state atoms |
| `src/Providers/` | 28 React context providers |
| `src/data-provider/` | React Query hooks by feature area |
| `src/hooks/` | 50+ custom hook categories |
| `src/locales/` | 41 language translations |

### Backend (`api/` + `packages/api/`)
| Directory | Purpose |
|-----------|---------|
| `api/server/routes/` | HTTP route handlers (legacy JS) |
| `api/strategies/` | 13 Passport auth strategies |
| `packages/api/src/endpoints/` | New TS route handlers |
| `packages/api/src/agents/` | AI agent logic |
| `packages/api/src/mcp/` | MCP integration |
| `packages/api/src/stream/` | SSE streaming |
| `packages/api/src/cache/` | Redis caching |
| `packages/api/src/db/` | Database operations |

### Shared (`packages/data-provider/` + `packages/data-schemas/`)
| Directory | Purpose |
|-----------|---------|
| `data-provider/src/api-endpoints.ts` | All API URL definitions |
| `data-provider/src/data-service.ts` | Data service methods |
| `data-provider/src/keys.ts` | QueryKeys + MutationKeys |
| `data-provider/src/types/` | Shared TypeScript types |
| `data-schemas/src/schema/` | 27 Mongoose schema definitions |
| `data-schemas/src/models/` | Model factory functions |

## Integration Points

```
client/ ──[React Query]──> packages/data-provider ──[Axios]──> api/server/routes/
                                    │                                    │
                                    │                              [calls into]
                                    │                                    │
                                    └──[types/schemas]──> packages/api/src/
                                                                │
                                                          [uses models from]
                                                                │
                                                    packages/data-schemas/
```
