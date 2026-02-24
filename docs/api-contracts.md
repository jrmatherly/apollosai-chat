# LibreChat API Contracts

> Generated: 2026-02-23 | Scan Level: Deep | Total Endpoints: 100+

## Overview

LibreChat exposes a RESTful API through Express.js routes, with endpoint URLs defined in `packages/data-provider/src/api-endpoints.ts` and data service methods in `packages/data-provider/src/data-service.ts`. All authenticated endpoints use JWT-based auth via Passport.

## Authentication Endpoints

**Base Path:** `/api/auth`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/login` | User login with credentials | No |
| POST | `/logout` | User logout | Yes |
| POST | `/register` | Register new user account | No |
| POST | `/refresh` | Refresh JWT token | No |
| POST | `/requestPasswordReset` | Request password reset email | No |
| POST | `/resetPassword` | Reset password with token | No |
| GET | `/2fa/enable` | Initialize 2FA setup | Yes |
| POST | `/2fa/verify` | Verify 2FA code | Yes |
| POST | `/2fa/verify-temp` | Verify temporary 2FA token | No |
| POST | `/2fa/confirm` | Confirm 2FA enablement | Yes |
| POST | `/2fa/disable` | Disable 2FA | Yes |
| POST | `/2fa/backup/regenerate` | Regenerate 2FA backup codes | Yes |
| GET | `/graph-token` | Get SharePoint Graph API token | Yes |

## User Endpoints

**Base Path:** `/api/user`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | Get authenticated user profile | Yes |
| GET | `/terms` | Get user terms acceptance status | Yes |
| POST | `/terms/accept` | Accept terms of service | Yes |
| POST | `/plugins` | Update user plugin settings | Yes |
| DELETE | `/delete` | Delete user account | Yes |
| POST | `/verify` | Verify email address | No |
| POST | `/verify/resend` | Resend email verification | No |

## Conversation Endpoints

**Base Path:** `/api/convos`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | List conversations (cursor-paginated) | Yes |
| GET | `/:conversationId` | Get conversation details | Yes |
| POST | `/update` | Update conversation title | Yes |
| POST | `/archive` | Archive/unarchive conversation | Yes |
| DELETE | `/` | Delete specific conversation | Yes |
| DELETE | `/all` | Delete all conversations | Yes |
| POST | `/import` | Import conversation from JSON | Yes |
| POST | `/fork` | Fork conversation from message | Yes |
| POST | `/duplicate` | Duplicate conversation | Yes |
| GET | `/gen_title/:conversationId` | Generate conversation title | Yes |

## Message Endpoints

**Base Path:** `/api/messages`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | List messages with filters | Yes |
| GET | `/:conversationId` | Get messages for conversation | Yes |
| POST | `/:conversationId` | Save new message | Yes |
| GET | `/:conversationId/:messageId` | Get specific message | Yes |
| PUT | `/:conversationId/:messageId` | Update message text/content | Yes |
| PUT | `/:conversationId/:messageId/feedback` | Submit message feedback | Yes |
| DELETE | `/:conversationId/:messageId` | Delete message | Yes |
| POST | `/branch` | Create branch from agent content | Yes |
| POST | `/artifact/:messageId` | Edit artifact in message | Yes |

## Agent Endpoints

**Base Path:** `/api/agents`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/` | Create new agent | Yes |
| GET | `/` | List agents | Yes |
| GET | `/:agent_id` | Get agent details | Yes |
| GET | `/:agent_id/expanded` | Get agent with expanded details | Yes |
| PATCH | `/:agent_id` | Update agent | Yes |
| DELETE | `/:agent_id` | Delete agent | Yes |
| POST | `/:agent_id/duplicate` | Duplicate agent | Yes |
| POST | `/:agent_id/revert` | Revert to previous agent version | Yes |
| GET | `/tools` | Get available agent tools | Yes |
| GET | `/tools/:toolId/auth` | Verify tool authentication | Yes |
| POST | `/tools/:toolId/call` | Call a tool | Yes |
| GET | `/tools/calls` | Get tool call results | Yes |
| POST | `/actions/:agent_id` | Update agent action | Yes |
| DELETE | `/actions/:agent_id/:action_id` | Delete agent action | Yes |
| GET | `/categories` | Get marketplace categories | Yes |

### Agent Streaming (SSE)

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/chat/stream/:streamId` | Subscribe to generation stream | Yes |
| GET | `/chat/active` | Get active agent jobs | Yes |
| GET | `/chat/status/:conversationId` | Get generation job status | Yes |
| POST | `/chat/abort` | Abort generation job | Yes |

### Agent API (OpenAI-Compatible)

**Base Path:** `/api/agents/v1`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/chat/completions` | OpenAI-compatible completions | API Key |
| POST | `/responses` | Open Responses API | API Key |

## Assistant Endpoints

**Base Path:** `/api/assistants`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/v1` | Create assistant (v1) | Yes |
| GET | `/v1` | List assistants (v1) | Yes |
| GET | `/v1/:assistant_id` | Get assistant details (v1) | Yes |
| PATCH | `/v1/:assistant_id` | Update assistant (v1) | Yes |
| DELETE | `/v1/:assistant_id` | Delete assistant (v1) | Yes |
| GET | `/v1/documents` | Get assistant documents | Yes |
| GET | `/v1/tools` | Get available tools | Yes |
| POST | `/v1/actions/:assistant_id` | Update assistant action | Yes |
| DELETE | `/v1/actions/:assistant_id/:action_id/:model` | Delete assistant action | Yes |
| POST | `/v1/chat/completions` | Chat completions (v1) | Yes |
| POST | `/v2/chat/completions` | Chat completions (v2) | Yes |
| POST | `/v2` | Create assistant (v2) | Yes |
| GET | `/v2` | List assistants (v2) | Yes |
| GET | `/v2/:assistant_id` | Get assistant details (v2) | Yes |
| PATCH | `/v2/:assistant_id` | Update assistant (v2) | Yes |
| DELETE | `/v2/:assistant_id` | Delete assistant (v2) | Yes |

## File Endpoints

**Base Path:** `/api/files`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | List uploaded files | Yes |
| POST | `/` | Upload file | Yes |
| DELETE | `/` | Delete files (batch) | Yes |
| GET | `/config` | Get file config | Yes |
| GET | `/download/:userId/:fileId` | Download file | Yes |
| GET | `/agent/:agentId` | Get agent files | Yes |
| POST | `/images` | Upload image | Yes |
| POST | `/images/avatar` | Upload user avatar | Yes |
| POST | `/images/agents/:agent_id/avatar` | Upload agent avatar | Yes |
| POST | `/images/assistants/:assistant_id/avatar` | Upload assistant avatar | Yes |

### Speech Endpoints

**Base Path:** `/api/files/speech`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/stt` | Speech-to-text conversion | Yes |
| POST | `/tts/manual` | Text-to-speech conversion | Yes |
| GET | `/tts/voices` | Get available TTS voices | Yes |
| GET | `/config/get` | Get speech configuration | Yes |

## MCP Endpoints

**Base Path:** `/api/mcp`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/tools` | Get all MCP tools | Yes |
| GET | `/servers` | List MCP servers | Yes |
| POST | `/servers` | Create MCP server | Yes |
| GET | `/servers/:serverName` | Get MCP server details | Yes |
| PATCH | `/servers/:serverName` | Update MCP server | Yes |
| DELETE | `/servers/:serverName` | Delete MCP server | Yes |
| POST | `/:serverName/reinitialize` | Reinitialize MCP server | Yes |
| GET | `/connection/status` | Get all server status | Yes |
| GET | `/connection/status/:serverName` | Get specific server status | Yes |
| GET | `/:serverName/auth-values` | Check auth values exist | Yes |
| GET | `/:serverName/oauth/initiate` | Start OAuth flow | Yes |
| GET | `/:serverName/oauth/callback` | OAuth callback handler | No |
| POST | `/:serverName/oauth/bind` | Bind OAuth CSRF cookie | Yes |
| POST | `/oauth/cancel/:serverName` | Cancel OAuth flow | Yes |
| GET | `/oauth/tokens/:flowId` | Get completed OAuth tokens | Yes |
| GET | `/oauth/status/:flowId` | Check OAuth flow status | Yes |

## Prompts Endpoints

**Base Path:** `/api/prompts`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | List prompts | Yes |
| GET | `/all` | Get all accessible prompts | Yes |
| GET | `/groups` | List prompt groups (paginated) | Yes |
| GET | `/groups/:groupId` | Get prompt group details | Yes |
| POST | `/` | Create prompt/group | Yes |
| POST | `/groups/:groupId/prompts` | Add prompt to group | Yes |
| GET | `/:promptId` | Get specific prompt | Yes |
| PATCH | `/groups/:groupId` | Update prompt group | Yes |
| PATCH | `/:promptId/tags/production` | Mark prompt as production | Yes |
| PATCH | `/:promptId/labels` | Update prompt labels | Yes |
| DELETE | `/:promptId` | Delete prompt | Yes |
| DELETE | `/groups/:groupId` | Delete prompt group | Yes |

## Permissions & Roles Endpoints

**Base Path:** `/api/roles`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/:roleName` | Get role details | Yes |
| PUT | `/:roleName/prompts` | Update prompt permissions | Admin |
| PUT | `/:roleName/agents` | Update agent permissions | Admin |
| PUT | `/:roleName/memories` | Update memory permissions | Admin |
| PUT | `/:roleName/people-picker` | Update people picker perms | Admin |
| PUT | `/:roleName/mcp-servers` | Update MCP server perms | Admin |
| PUT | `/:roleName/marketplace` | Update marketplace perms | Admin |
| PUT | `/:roleName/remote-agents` | Update remote agent perms | Admin |

**Base Path:** `/api/permissions`

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/search-principals` | Search for users/groups | Yes |
| GET | `/:resourceType/roles` | Get roles for resource type | Yes |
| GET | `/:resourceType/:resourceId` | Get resource permissions | Yes |
| PUT | `/:resourceType/:resourceId` | Update resource permissions | Yes |
| GET | `/:resourceType/:resourceId/effective` | Get effective permissions | Yes |
| GET | `/:resourceType/effective/all` | Get all effective permissions | Yes |

## Additional Endpoints

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/api/config` | Get startup configuration | No |
| GET | `/api/endpoints` | Get available AI endpoints | No |
| GET | `/api/models` | Get available models | No |
| GET | `/api/balance` | Get account balance | Yes |
| GET | `/api/banner` | Get banner message | No |
| GET | `/api/search/enable` | Check if search enabled | Yes |
| GET | `/health` | Health check | No |

### Memory Endpoints (`/api/memories`)

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | Get user memories | Yes |
| POST | `/` | Create memory entry | Yes |
| PATCH | `/:key` | Update memory value | Yes |
| DELETE | `/:key` | Delete memory | Yes |
| PATCH | `/preferences` | Update memory preferences | Yes |

### API Keys (`/api/keys`)

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | Get user key expiry | Yes |
| PUT | `/` | Create/update user key | Yes |
| DELETE | `/:name` | Revoke specific user key | Yes |
| DELETE | `/` | Revoke all user keys | Yes |

### Shared Links (`/api/share`)

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/:shareId` | Get shared conversation messages | Optional |
| GET | `/` | List user's shared links | Yes |
| GET | `/link/:conversationId` | Get share link for conversation | Yes |
| POST | `/:conversationId` | Create share link | Yes |
| PATCH | `/:shareId` | Update share link settings | Yes |
| DELETE | `/:shareId` | Delete share link | Yes |

### Tags (`/api/tags`)

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | List conversation tags | Yes |
| POST | `/` | Create conversation tag | Yes |
| PUT | `/:tag` | Update conversation tag | Yes |
| DELETE | `/:tag` | Delete conversation tag | Yes |
| PUT | `/convo/:conversationId` | Add/update tags on conversation | Yes |
| POST | `/rebuild` | Rebuild tag system | Yes |

### Presets (`/api/presets`)

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/` | List presets | Yes |
| POST | `/` | Create/update preset | Yes |
| POST | `/delete` | Delete preset | Yes |

## Architecture Notes

- **Rate Limiting**: Applied to file uploads, message submissions, imports, password resets
- **Streaming**: Agent/assistant chat uses Server-Sent Events (SSE) for real-time responses
- **Pagination**: Cursor-based pagination for conversations, messages, prompts
- **Multi-Version**: Assistants API supports both v1 and v2 for backward compatibility
- **OpenAI-Compatible**: Agent API provides `/v1/chat/completions` for external integration
