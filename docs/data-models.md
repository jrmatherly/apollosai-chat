# LibreChat Data Models

> Generated: 2026-02-23 | Scan Level: Deep | Total Models: 27

## Architecture Overview

All models are created via `createModels(mongoose)` factory in `/packages/data-schemas/src/models/index.ts`. Custom methods use `createMethods(mongoose)` with an `AllMethods` type union.

**Locations:**
- Schema definitions: `/packages/data-schemas/src/schema/`
- Model factories: `/packages/data-schemas/src/models/`
- TypeScript types: `/packages/data-schemas/src/types/`
- Custom methods: `/packages/data-schemas/src/methods/`

## Models by Domain

### 1. User Management & Authentication

#### User (`users`)
| Field | Type | Notes |
|-------|------|-------|
| `email` | String | Required, unique, indexed, regex validated |
| `username` | String | Lowercase, default empty |
| `password` | String | 8-128 chars, select:false |
| `name` | String | Display name |
| `avatar` | String | Avatar URL |
| `role` | String | Default: SystemRoles.USER |
| `provider` | String | Default: 'local' |
| `emailVerified` | Boolean | Required, default: false |
| `googleId`, `facebookId`, `openidId`, `samlId`, `ldapId`, `githubId`, `discordId`, `appleId` | String | Each unique, sparse |
| `twoFactorEnabled` | Boolean | Default: false |
| `totpSecret` | String | select:false |
| `backupCodes` | Array | Sub-schema: {codeHash, used, usedAt} |
| `refreshToken` | Array | Sub-schema with TTL 7 days |
| `termsAccepted` | Boolean | Default: false |
| `personalization` | Object | {memories: Boolean} |
| `favorites` | Array | {agentId?, model?, endpoint?} |

#### Session (`sessions`)
| Field | Type | Notes |
|-------|------|-------|
| `refreshTokenHash` | String | Required |
| `expiration` | Date | Required, TTL: 0 |
| `user` | ObjectId ref User | Required |

#### Token (`tokens`)
| Field | Type | Notes |
|-------|------|-------|
| `userId` | ObjectId ref User | Required |
| `email` | String | |
| `type` | String | Token type |
| `token` | String | Required |
| `expiresAt` | Date | TTL index |
| `metadata` | Map of Mixed | |

### 2. Conversations & Messaging

#### Conversation (`conversations`)
| Field | Type | Notes |
|-------|------|-------|
| `conversationId` | String | Unique, required, indexed |
| `title` | String | Default: 'New Chat', MeiliSearch indexed |
| `user` | String | Indexed, MeiliSearch indexed |
| `messages` | Array ObjectId ref Message | |
| `agent_id` | String | |
| `tags` | Array String | Default: [], MeiliSearch indexed |
| `expiredAt` | Date | TTL field |
| _+ 40+ inherited fields from conversationPreset_ | | endpoint, model, temperature, top_p, maxTokens, system, etc. |

**Indexes:** expiredAt (TTL), createdAt+updatedAt, conversationId+user (unique), _meiliIndex+expiredAt

#### Message (`messages`)
| Field | Type | Notes |
|-------|------|-------|
| `messageId` | String | Unique, required, indexed, MeiliSearch |
| `conversationId` | String | Indexed, required, MeiliSearch |
| `user` | String | Indexed, required |
| `model` | String | |
| `endpoint` | String | |
| `sender` | String | MeiliSearch indexed |
| `text` | String | MeiliSearch indexed |
| `isCreatedByUser` | Boolean | Required, default: false |
| `unfinished` | Boolean | Default: false |
| `error` | Boolean | Default: false |
| `feedback` | Object | {rating: enum[thumbsUp,thumbsDown], tag, text} |
| `files` | Array Mixed | |
| `content` | Array Mixed | MeiliSearch indexed |
| `attachments` | Array Mixed | |

**Indexes:** expiredAt (TTL), createdAt, messageId+user (unique), _meiliIndex+expiredAt

#### Conversation Tag (`conversationtags`)
| Field | Type | Notes |
|-------|------|-------|
| `tag` | String | Indexed |
| `user` | String | Indexed |
| `description` | String | Indexed |
| `count` | Number | Default: 0 |
| `position` | Number | Default: 0, indexed |

**Indexes:** tag+user (unique composite)

#### Tool Call (`toolcalls`)
| Field | Type | Notes |
|-------|------|-------|
| `conversationId` | String | Required |
| `messageId` | String | Required |
| `toolId` | String | Required |
| `user` | ObjectId ref User | Required |
| `result` | Mixed | |
| `blockIndex` | Number | |

### 3. Agents & Assistants

#### Agent (`agents`)
| Field | Type | Notes |
|-------|------|-------|
| `id` | String | Indexed, unique, required (custom ID) |
| `name` | String | |
| `description` | String | |
| `instructions` | String | System prompt |
| `provider` | String | Required |
| `model` | String | Required |
| `tools` | Array String | |
| `tool_resources` | Mixed | Default: {} |
| `tool_options` | Mixed | Per-tool config (defer_loading, allowed_callers) |
| `actions` | Array String | |
| `author` | ObjectId ref User | Required |
| `edges` | Array Mixed | Graph edges for composite agents |
| `category` | String | Indexed, default: 'general' |
| `is_promoted` | Boolean | Indexed, default: false |
| `projectIds` | Array ObjectId ref Project | Indexed |
| `versions` | Array Mixed | Default: [] |
| `mcpServerNames` | Array String | Indexed |
| `conversation_starters` | Array String | Default: [] |

#### Assistant (`assistants`)
| Field | Type | Notes |
|-------|------|-------|
| `user` | ObjectId ref User | Required |
| `assistant_id` | String | Indexed, required (OpenAI ID) |
| `avatar` | Mixed | |
| `conversation_starters` | Array String | Default: [] |
| `access_level` | Number | |
| `actions` | Array String | |

#### Agent Category (`agentcategories`)
| Field | Type | Notes |
|-------|------|-------|
| `value` | String | Unique, indexed, lowercase |
| `label` | String | Required |
| `order` | Number | Indexed, default: 0 |
| `isActive` | Boolean | Indexed, default: true |

#### Agent API Key (`agentapikeys`)
| Field | Type | Notes |
|-------|------|-------|
| `userId` | ObjectId ref User | Required, indexed |
| `name` | String | Required, max 100 |
| `keyHash` | String | Required, select:false |
| `keyPrefix` | String | Required, indexed |
| `expiresAt` | Date | TTL: 0 |

### 4. Prompts & Templates

#### Prompt (`prompts`)
| Field | Type | Notes |
|-------|------|-------|
| `groupId` | ObjectId ref PromptGroup | Required, indexed |
| `author` | ObjectId ref User | Required |
| `prompt` | String | Required |
| `type` | String | Enum: ['text', 'chat'], required |

#### Prompt Group (`promptgroups`)
| Field | Type | Notes |
|-------|------|-------|
| `name` | String | Required, indexed |
| `command` | String | Indexed, regex: `/^[a-z0-9-]+$/` |
| `projectIds` | Array ObjectId ref Project | Indexed |
| `productionId` | ObjectId ref Prompt | Required, indexed |
| `author` | ObjectId ref User | Required, indexed |
| `authorName` | String | Required |

### 5. Files & Attachments

#### File (`files`)
| Field | Type | Notes |
|-------|------|-------|
| `user` | ObjectId ref User | Required, indexed |
| `file_id` | String | Indexed, required |
| `filename` | String | Required |
| `filepath` | String | Required |
| `bytes` | Number | Required |
| `type` | String | Required (MIME type) |
| `source` | String | Default: FileSources.local |
| `expiresAt` | Date | TTL: 3600 seconds |

### 6. Permissions & Access Control

#### Role (`roles`)
| Field | Type | Notes |
|-------|------|-------|
| `name` | String | Unique, indexed, required |
| `permissions` | Object | Nested: 8 PermissionTypes x multiple Permissions |

**Permission Types:** BOOKMARKS, PROMPTS, MEMORIES, AGENTS, MULTI_CONVO, TEMPORARY_CHAT, RUN_CODE, WEB_SEARCH, PEOPLE_PICKER, MARKETPLACE, FILE_SEARCH, FILE_CITATIONS, MCP_SERVERS, REMOTE_AGENTS

#### Access Role (`accessroles`)
| Field | Type | Notes |
|-------|------|-------|
| `accessRoleId` | String | Unique, indexed, required |
| `resourceType` | String | Enum: ['agent', 'project', 'file', 'promptGroup', 'mcpServer', 'remoteAgent'] |
| `permBits` | Number | Required (bitwise flags) |

#### ACL Entry (`aclentries`)
| Field | Type | Notes |
|-------|------|-------|
| `principalType` | String | Enum: USER, GROUP, ROLE, PUBLIC |
| `principalId` | Mixed | ObjectId or String |
| `resourceType` | String | ResourceType enum |
| `resourceId` | ObjectId | Required, indexed |
| `permBits` | Number | Default: 1 (bitwise) |
| `roleId` | ObjectId ref AccessRole | |

#### Group (`groups`)
| Field | Type | Notes |
|-------|------|-------|
| `name` | String | Required, indexed |
| `memberIds` | Array String | |
| `source` | String | Enum: ['local', 'entra'], default: 'local' |
| `idOnTheSource` | String | Sparse, indexed (external ID) |

### 7. Additional Models

#### MCP Server (`mcpservers`)
| Field | Type | Notes |
|-------|------|-------|
| `serverName` | String | Unique, indexed, required |
| `config` | Mixed | Required (title, description, url, oauth, etc.) |
| `author` | ObjectId ref User | Required, indexed |

#### Shared Link (`sharedlinks`)
| Field | Type | Notes |
|-------|------|-------|
| `conversationId` | String | Required |
| `shareId` | String | Indexed |
| `user` | String | Indexed |
| `isPublic` | Boolean | Default: true |

#### Project (`projects`)
| Field | Type | Notes |
|-------|------|-------|
| `name` | String | Required, indexed |
| `promptGroupIds` | Array ObjectId ref PromptGroup | |
| `agentIds` | Array String ref Agent | |

#### Balance (`balances`)
| Field | Type | Notes |
|-------|------|-------|
| `user` | ObjectId ref User | Required, indexed |
| `tokenCredits` | Number | Default: 0 (1000 = $0.001) |
| `autoRefillEnabled` | Boolean | Default: false |

#### Transaction (`transactions`)
| Field | Type | Notes |
|-------|------|-------|
| `user` | ObjectId ref User | Required, indexed |
| `tokenType` | String | Enum: ['prompt', 'completion', 'credits'] |
| `model` | String | Indexed |

#### Memory Entry (`memoryentries`)
| Field | Type | Notes |
|-------|------|-------|
| `userId` | ObjectId ref User | Required, indexed |
| `key` | String | Required, regex: `/^[a-z_]+$/` |
| `value` | String | Required |
| `tokenCount` | Number | Default: 0 |

#### Action (`actions`), Plugin Auth (`pluginauths`), Banner (`banners`), Key (`keys`), Preset (`presets`)
See full schema details in `/packages/data-schemas/src/schema/`

## Schema Design Patterns

1. **Conversation Preset Inheritance**: Conversation and Preset share 40+ configuration fields via `conversationPreset` object
2. **MeiliSearch Integration**: Searchable fields marked with `meiliIndex: true` + `_meiliIndex` sync tracking
3. **TTL Indexes**: Auto-expiration on sessions, messages, conversations, files, API keys, tokens
4. **Composite Unique Indexes**: Multi-field constraints (conversationId+user, tag+user, etc.)
5. **Reference Patterns**: Direct refs (`ref: 'User'`), polymorphic refs (`refPath`), and string-based IDs
6. **Sub-schemas**: Embedded objects without `_id` (BackupCodeSchema, AuthSchema, etc.)

## Migration Strategy

- Ad-hoc migrations in `/config/` (e.g., `migrate-agent-permissions.js`, `migrate-prompt-permissions.js`)
- Supports `--dry-run` flag for testing
- Batch processing for large datasets
- Role seeding via `seedDefaultRoles()` and `initializeRoles()`
- Collection initialization via `ensureRequiredCollectionsExist()` in `/packages/api/src/db/utils.ts`
