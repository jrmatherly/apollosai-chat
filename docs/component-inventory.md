# LibreChat Component Inventory

> Generated: 2026-02-23 | Scan Level: Deep | Total Components: 630+

## State Management Architecture

LibreChat uses a **4-tier state management** approach:

| Tier | Library | Purpose | Location |
|------|---------|---------|----------|
| Global UI | Recoil | User, artifacts, endpoints, settings | `client/src/store/` (22 store files) |
| Persisted | Jotai | localStorage prefs with tab isolation | `client/src/store/` (jotai-utils.ts) |
| Feature-scoped | React Context | Reduce prop drilling, feature encapsulation | `client/src/Providers/` (28 contexts) |
| Server state | React Query | API caching, mutations, query invalidation | `client/src/data-provider/` (11 feature areas) |

### Recoil Stores
- `artifacts.ts` - Artifact state, current artifact ID, visibility
- `user.ts` - User profile, available tools
- `endpoints.ts` - Available endpoints configuration
- `families.ts` - Endpoint families
- `preset.ts` - Conversation presets
- `prompts.ts` - Prompt management state
- `language.ts` - UI language/localization
- `settings.ts` - Application settings
- `misc.ts` - Miscellaneous UI flags
- `text.ts` - Text editor state
- `toast.ts` - Toast notification queue
- `submission.ts` - Form submission state
- `search.ts` - Search UI state
- `fontSize.ts` - Font size preference
- `temporary.ts` - Temporary/ephemeral state
- `showThinking.ts` - Thinking visibility toggle

### Jotai Stores
- `mcp.ts` - MCP server state with `atomFamily` for per-conversation storage, tab-isolated
- `agents.ts` - Agent selection, agent panel state
- `favorites.ts` - Favorites management with optimistic UI

### Context Providers (28)
**Feature:** ChatContext, ChatFormContext, MessageContext, ArtifactContext, BookmarkContext, EditorContext, SearchContext
**Collections:** AgentsContext, AgentsMapContext, AssistantsContext, AssistantsMapContext, ArtifactsContext, ToolCallsMapContext
**UI State:** ActivePanelContext, AgentPanelContext, SidePanelContext, DashboardContext, AnnouncerContext, BadgeRowContext, DragDropContext, FileMapContext, AddedChatContext, CodeBlockContext, SetConvoContext, ShareContext, MessagesViewContext, PromptGroupsContext

### React Query Feature Areas (11)
Auth, Agents, Endpoints, Messages, Files, Tools, MCP, Memories, SSE, Misc, Favorites

### Custom Hooks (50+ categories)
Organized in `client/src/hooks/`:
- `Agents/` (10), `Artifacts/` (3), `Assistants/` (3), `Audio/` (6), `Chat/` (7)
- `Config/` (3), `Conversations/` (12), `Endpoint/` (3), `Files/` (12), `Generic/` (2)
- `Input/` (15), `MCP/` (5), `Mermaid/` (2)

---

## UI Component Directory

### Chat System (`Chat/` - 120+ components)

**Core Layout:** ChatView, Landing, Footer, Header

**Input Subsystem (70+ files):**
- ChatForm - Main input form
- Files/ (25+ components) - File upload, drag-drop, table, preview
- AudioRecorder - Voice input
- MCPSelect, MCPConfigDialog - MCP tool selection
- ConversationStarters - Suggested prompts
- BadgeRow - Active tools/files display
- Mention - @mentions system

**Message Rendering (40+ components):**
- MessagesView - Message container
- Message - Individual message display
- Content/ (30+ components):
  - MessageContent - Content dispatcher
  - Markdown, MarkdownLite - Markdown rendering
  - ToolCall, ToolCallInfo - Tool execution display
  - WebSearch - Search results
  - RetrievalCall - RAG retrieval display
  - Thinking - Extended thinking display
  - ExecuteCode - Code execution results
  - ImageGen, OpenAIImageGen - Image generation
  - ParallelContent - Parallel reasoning branches
  - MemoryArtifacts, MemoryInfo - Memory interactions

**Menus (25+ components):**
- ModelSelector, CustomMenu - Endpoint/model selection
- PresetsMenu - Preset management
- BookmarkMenu - Bookmark actions
- Endpoints/ (12 components) - Endpoint browsing

### Side Panel System (`SidePanel/` - 140+ components)

**Major Panels:** Nav, Parameters, Memories (8), Bookmarks (5), Files (4)

**MCP Builder (25+ components):**
- MCPServerDialog/ - Form-based server setup
- Sections: Auth, Basic Info, Connection, Transport, Trust

**Agent Builder (60+ components):**
- AgentPanel, AgentConfig - Main editor
- ModelPanel, Instructions - Basic setup
- MCPTools - MCP tool picker
- Retrieval, FileSearch, Code/ - Capability toggles
- Advanced/ (4) - Agent chaining, handoffs, step limits
- Version/ (4) - Version history browser
- Search/ (3) - Web search configuration

**Assistant Builder (25+ components):**
- AssistantPanel - Main editor
- AssistantTool - Tool management
- ActionsPanel, ActionsTable/ - OpenAPI actions
- Knowledge, Retrieval - RAG setup

### Navigation & Settings (`Nav/` - 100+ components)

**Main Navigation:** Nav, MobileNav, SearchBar, NewChat, AccountSettings

**Settings Tabs (80+ components):**
- Account/ (10) - Profile, 2FA, delete account
- General/ (5) - Theme, language, archived chats
- Chat/ (6) - Font size, fork settings, thinking display
- Data/ (7) - Export, import, API keys, cache clear
- Speech/ (15+) - STT/TTS engines, voices, playback
- Balance/ (3) - Credits, token balance, auto-refill
- Commands/ (1) - Shortcuts

### Authentication (`Auth/` - 17 components)
Login, LoginForm, Registration, TwoFactorScreen, VerifyEmail, RequestPasswordReset, ResetPassword, SocialButton, SocialLoginRender, AuthLayout, ErrorMessage, ApiErrorWatcher

### Agent Marketplace (`Agents/` - 23 components)
Marketplace, AgentGrid, VirtualizedAgentGrid (virtualized for performance), AgentCard, AgentDetail, CategoryTabs, SearchBar, SmartLoader

### Prompts (`Prompts/` - 37 components)
PromptsView, ManagePrompts, PromptEditor, PromptForm, PromptDetails, PromptVersions, PromptsAccordion, Groups/ (13 components)

### Other Directories

| Directory | Count | Purpose |
|-----------|-------|---------|
| Artifacts/ | 10 | Artifact viewer, code editor, preview |
| Conversations/ | 6 | Conversation list, items, rename |
| Endpoints/ | 13 | Endpoint icons, settings, selection |
| Files/ | 30+ | File management, vector stores |
| Messages/ | 40+ | Message rendering, content types |
| Bookmarks/ | 7 | Bookmark cards, lists, dialogs |
| Sharing/ | 8 | Share dialogs, access control, people picker |
| Share/ | 5 | Share view for conversations/artifacts |
| Web/ | 5 | Web search results, citations |
| Input/ | 10+ | Model selectors, generation controls |
| MCP/ | 6 | MCP configuration, server dialogs |
| Banners/ | 1 | Alert/info banners |
| OAuth/ | 2 | OAuth flow screens |

## Design System

**UI Framework:** Radix UI primitives + TailwindCSS + Lucide React icons
**Tables:** TanStack Table with column visibility, sort, filter
**Forms:** React Hook Form
**Animation:** Framer Motion + React Spring
**Virtualization:** TanStack Virtual for large lists
**Markdown:** react-markdown + rehype/remark plugins
**Charts/Diagrams:** Mermaid

## Naming Conventions

- `useXxx` - Custom hooks
- `XxxProvider` - Context providers
- `XxxContext` - Context objects
- `XxxPanel`, `XxxDialog`, `XxxModal` - Container components
- `XxxButton`, `XxxToggle`, `XxxSelect` - UI primitives

## Localization

- **41 languages** supported via react-i18next
- English keys: `client/src/locales/en/translation.json`
- Semantic prefixes: `com_ui_`, `com_assistants_`, `com_agents_`, etc.
- All user-facing text uses `useLocalize()` hook
