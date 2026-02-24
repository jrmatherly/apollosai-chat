# LibreChat Project Overview

> Generated: 2026-02-23 | Version: v0.8.3-rc1

## Purpose

LibreChat is an open-source AI chat application that provides a unified interface for multiple AI providers (OpenAI, Anthropic, Google, AWS Bedrock, Ollama). It supports agents with tool use, MCP integration, file handling, code execution, web search, and a prompt management system.

## Executive Summary

| Property | Value |
|----------|-------|
| **Version** | v0.8.3-rc1 |
| **Repository Type** | Monorepo (npm workspaces + Turborepo) |
| **Primary Language** | TypeScript |
| **Frontend** | React 18 SPA (Vite, TailwindCSS, React Query) |
| **Backend** | Node.js + Express 5 (legacy JS + new TS) |
| **Database** | MongoDB (Mongoose, 27 models) |
| **Cache** | Redis (ioredis) |
| **Search** | MeiliSearch |
| **Authentication** | 13 Passport strategies (local, JWT, OAuth, LDAP, SAML, OpenID) |
| **AI Providers** | OpenAI, Anthropic, Google GenAI, AWS Bedrock, Ollama |
| **Agent Framework** | @librechat/agents v3.1.51 |
| **MCP Support** | @modelcontextprotocol/sdk v1.26.0 |
| **Components** | 630+ React components |
| **API Endpoints** | 100+ REST endpoints |
| **Languages** | 41 i18n translations |
| **Docker Services** | 15 (dev stack) |

## Architecture Classification

**Type**: Full-stack web application (monorepo)
**Pattern**: Component-based SPA frontend + Express middleware pipeline backend
**State**: 4-tier (Recoil → Jotai → Context → React Query)
**Data Flow**: Frontend → data-provider (shared) → REST API → Service layer → MongoDB

## Key Features

- **Multi-Provider Chat**: Unified interface for OpenAI, Anthropic, Google, Bedrock, Ollama
- **AI Agents**: Custom agents with tool use, composite agent chaining, version history
- **Agent Marketplace**: Browse, share, and discover agents
- **MCP Integration**: Connect external tools via Model Context Protocol with OAuth
- **OpenAI-Compatible API**: External integration at `/api/agents/v1/chat/completions`
- **Assistants API**: Support for OpenAI Assistants v1 and v2
- **Prompt Management**: Versioned prompts with groups, categories, and slash commands
- **File Handling**: Upload, manage, and use files in conversations (S3/Azure/local)
- **Code Execution**: Sandboxed Python code interpreter with seccomp
- **Speech**: Text-to-speech and speech-to-text integration
- **Web Search**: SearXNG-powered web search with Firecrawl scraping
- **RAG**: Retrieval Augmented Generation with vector database
- **User Memories**: Persistent user memory across conversations
- **Sharing**: Public/private conversation sharing with access control
- **RBAC**: Role-based access control with granular ACL
- **2FA**: Two-factor authentication with TOTP and backup codes
- **Enterprise Auth**: LDAP, SAML, OpenID Connect
- **Cursor Pagination**: Efficient pagination for all list endpoints
- **Real-time Streaming**: SSE-based streaming for AI responses
- **41 Languages**: Comprehensive internationalization

## Workspace Map

| Workspace | Path | Language | Role |
|-----------|------|----------|------|
| Frontend | `/client` | TypeScript/React | SPA application |
| Backend (legacy) | `/api` | JavaScript | Express server (minimize changes) |
| Backend (new) | `/packages/api` | TypeScript | New backend code |
| Data Provider | `/packages/data-provider` | TypeScript | Shared types, endpoints, React Query |
| Data Schemas | `/packages/data-schemas` | TypeScript | Mongoose models (27) |
| Client Utils | `/packages/client` | TypeScript | Shared frontend utilities |
