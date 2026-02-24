---
project_name: 'LibreChat'
user_name: 'Jason'
date: '2026-02-23'
sections_completed: ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'code_quality', 'workflow_rules', 'critical_rules']
status: 'complete'
rule_count: 72
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

### Critical Constraints (Will Cause Bugs If Ignored)

- **Express 5** (^5.2.1) — NOT Express 4. Route params, error middleware, and path matching differ. Do not reference Express 4 docs or patterns.
- **React Query v4** (^4.28.0) — NOT v5. Use `useQuery({ queryKey: [...], queryFn })` syntax. No `useSuspenseQuery`, no shorthand.
- **Mongoose 8** (^8.12.1) — `findOneAndUpdate` returns the document by default (no `new: true` needed). Query filter casting is stricter.
- **Jotai** (^2.12.5) is the primary atom state store. Recoil (^0.7.7) is legacy — all new state atoms use Jotai.
- **Jest 30** (^30.2.0) — Each workspace has its own jest config. Run tests from workspace directory: `cd <workspace> && npx jest`.
- **Pinned SDK overrides** — These are locked via npm overrides and MUST NOT be upgraded independently:
  - `@anthropic-ai/sdk`: 0.73.0
  - `axios`: 1.12.1
  - `fast-xml-parser`: 5.3.6
- **Package rebuilds are mandatory** — After changing `data-provider`, `data-schemas`, or `packages/api`, you MUST rebuild (`npm run build:data-provider`, etc.) before the backend or client can see changes.
- **TypeScript strict mode** enabled in all packages — no implicit any, strict null checks.

### Reference Stack

| Category | Technology | Version |
|---|---|---|
| Runtime | Node.js | >=20.19.0, ^22.12.0, >=23.0.0 |
| Package Manager | npm | 11.10.0 (workspaces monorepo) |
| Language | TypeScript | ^5.3.3 |
| Backend | Express | ^5.2.1 |
| Database | MongoDB via Mongoose | ^8.12.1 |
| Frontend | React | ^18.2.0 |
| Build (client) | Vite | ^6.4.1 |
| Build (packages) | Rollup | ^4.22.4 |
| Build orchestration | Turborepo | ^2.8.7 |
| Data fetching | @tanstack/react-query | ^4.28.0 |
| Validation | Zod | ^3.22.4 |
| i18n | i18next | ^24.2.2 (ESLint-enforced) |
| Testing | Jest ^30.2.0, Playwright ^1.56.1 |
| Linting | ESLint ^9.39.1 (flat config) |
| Formatting | Prettier ^3.5.0 (Tailwind plugin) |
| CSS | TailwindCSS | ^3.4.1 |
| State (atoms) | Jotai ^2.12.5 (primary), Recoil ^0.7.7 (legacy) |
| Caching | Redis via ioredis ^5.3.2 |
| Object Storage | AWS S3 SDK ^3.980.0 (MinIO-compatible) |
| LLM | @librechat/agents ^3.1.51 |
| Auth | Passport.js ^0.6.0 (13 strategies) |
| Search | MeiliSearch ^0.38.0 |
| Logging | Winston ^3.11.0 |

## Critical Implementation Rules

### Language-Specific Rules

- **Never use `any`** — explicit types for all parameters, return values, and variables. Use union types, generics, and interfaces.
- **Limit `unknown`** — avoid `Record<string, unknown>` and `as unknown as T` assertions. Define explicit types instead.
- **Don't duplicate types** — check `packages/data-provider/src/types/` before defining new types. Reuse and extend existing definitions.
- **Import ordering** (3 sections, strictly enforced):
  1. Package imports — sorted shortest to longest line length (`react` always first)
  2. `import type` — sorted longest to shortest (package types first, then local)
  3. Local imports — sorted longest to shortest
- **Standalone `import type`** — never inline `type` inside value imports. Use `import type { Foo }` separately.
- **No circular imports** — `import/no-cycle` and `import/no-self-import` are ESLint errors.
- **Path aliases** — `~/*` resolves to `src/*` in each workspace. Use them consistently.
- **Module formats** — `data-schemas` and `client` are ESM (`"type": "module"`); `packages/api` is CommonJS.
- **Unused vars** — prefix with `_` (e.g., `_unused`). ESLint is configured to allow `^_` pattern.
- **No nested ternaries** — ESLint warns. Use early returns or `if/else` instead.
- **Self-documenting code** — no inline comments narrating what code does. JSDoc only for complex/non-obvious logic.

### Framework-Specific Rules

#### Frontend (React)

- **Workspace boundary** — all frontend code in `client/src/`. Shared frontend utilities in `packages/client/`.
- **Data hooks pattern** — `client/src/data-provider/[Feature]/queries.ts` → `[Feature]/index.ts` → `client/src/data-provider/index.ts`. Always follow this chain.
- **Query/Mutation keys** — defined in `packages/data-provider/src/keys.ts` (QueryKeys + MutationKeys). Never hardcode key strings.
- **Endpoints** — defined in `packages/data-provider/src/api-endpoints.ts`, consumed via `data-service.ts`. Use `encodeURIComponent` for dynamic URL params.
- **Localization mandatory** — all user-facing text via `useLocalize()`. Only update English in `client/src/locales/en/translation.json`. Semantic prefixes: `com_ui_`, `com_assistants_`, etc.
- **Component organization** — PascalCase feature directories (`Chat/`, `SidePanel/`, `Agents/`). Group related components together. Use index files for exports.
- **State management** — Jotai atoms in `client/src/store/` for client state. React Query for server state. Never mix concerns.
- **Performance** — proper React Query dependency arrays, cursor pagination for large datasets, leverage caching and background refetching.
- **Accessibility** — semantic HTML with ARIA labels (`role`, `aria-label`). A11y ESLint rules are partially disabled but improving.

#### Backend (Express 5)

- **Workspace boundary** — ALL new backend code is TypeScript in `/packages/api`. Keep `/api` changes to absolute minimum (thin JS wrappers only).
- **Database models** — Mongoose schemas in `/packages/data-schemas/src/models/`. Shared logic in `/packages/data-schemas`.
- **Shared types** — API types, endpoints, data-service in `/packages/data-provider`. Used by BOTH frontend and backend.
- **Never-nesting** — early returns, flat code, minimal indentation. Break complex operations into well-named helpers.
- **Functional first** — pure functions, immutable data, `map`/`filter`/`reduce` over imperative loops. OOP only when it clearly improves modeling.
- **Minimize looping** — consolidate sequential O(n) operations into single pass. Use `Map`/`Set` for lookups instead of `Array.find`/`Array.includes`.

### Testing Rules

- **Run tests from workspace directory** — `cd api && npx jest <pattern>`, `cd packages/api && npx jest <pattern>`, etc. Never run Jest from root.
- **Frontend tests** — `__tests__` directories alongside components. Use `test/layout-test-utils` for rendering. Cover loading, success, and error states.
- **Backend test isolation** — `mongodb-memory-server` provides in-memory MongoDB. No external DB needed for unit tests.
- **Integration test naming** — `packages/api` uses `.cache_integration.spec.ts` and `.stream_integration.spec.ts` suffixes. These are excluded from default `test:ci` runs.
- **Mock conventions** — mock `data-provider` hooks and external dependencies. Don't mock internal implementation details.
- **E2E tests** — Playwright with separate configs: `playwright.config.local.ts` (dev), `playwright.config.ts` (CI), `playwright.config.a11y.ts` (accessibility).
- **Test commands** — `npm run test:client`, `npm run test:api`, `npm run test:packages:api`, `npm run test:all` for full suite.

### Code Quality & Style Rules

- **Prettier enforced as ESLint errors** — `printWidth: 100`, `singleQuote: true`, `trailingComma: "all"`, `semi: true`, `tabWidth: 2`. Tailwind class sorting via plugin.
- **All ESLint/TypeScript warnings and errors must be resolved** — do not leave unresolved diagnostics.
- **DRY** — extract repeated logic into utilities. Reusable hooks for UI patterns. Parameterized helpers instead of near-duplicate functions. Constants for repeated values.
- **No dynamic imports** unless absolutely necessary.
- **No over-engineering** — only make changes directly requested or clearly necessary. No extra features, no speculative abstractions, no docstrings/comments on unchanged code.
- **No backwards-compatibility hacks** — no renaming unused `_vars`, re-exporting types, or `// removed` comments. Delete unused code completely.
- **Loop preferences** — `for (let i...)` for performance-critical, `for...of` for simple iteration, `for...in` only for object enumeration. Prefer single-pass transformations.
- **File naming** — PascalCase for React components/directories, camelCase for utilities/hooks, kebab-case for config files.
- **Avoid unnecessary object creation** — consider space-time tradeoffs. Prevent memory leaks: careful with closures, dispose resources/event listeners.

### Development Workflow Rules

- **Build order is critical** — Turborepo handles this automatically with `npm run build`. Manual builds must follow: `data-provider` → `data-schemas` → `packages/api` → `packages/client` → `client`.
- **Rebuild after package changes** — any change to `packages/*` requires rebuilding that package before changes are visible. Use `npm run build:data-provider`, `npm run build:api`, etc.
- **Dev servers** — backend on port 3080 (`npm run backend:dev`), frontend on port 3090 (`npm run frontend:dev`). Frontend proxies `/api` and `/oauth` to backend.
- **Docker compose files** — `docker-compose.yml` (base), `docker-compose.dev.yml` (dev overrides), `docker-compose.prod.yml` (production). Use `-f` flag to combine.
- **Dependency installation** — `npm run smart-reinstall` (preferred, conditional install + build). `npm run reinstall` (clean wipe). Never run `npm install` directly in sub-workspaces.
- **Husky + lint-staged** — pre-commit hooks are configured. Do not bypass with `--no-verify`.
- **Nodemon ignores** — `api/data/`, `data/`, `client/`, `admin/`, `packages/` are excluded from backend watch. Package changes require manual rebuild.

### Critical Don't-Miss Rules

#### Anti-Patterns to Avoid

- **DO NOT put new backend code in `/api`** — this is the #1 mistake. All new backend TypeScript goes in `/packages/api`. The `/api` directory is legacy JS; only add thin wrappers there.
- **DO NOT hardcode query keys** — always use `QueryKeys` and `MutationKeys` from `packages/data-provider/src/keys.ts`.
- **DO NOT use React Query v5 patterns** — no `useSuspenseQuery`, no shorthand `useQuery(key, fn)`. This is v4.
- **DO NOT create new Recoil atoms** — use Jotai for all new client state.
- **DO NOT add literal strings in JSX** — ESLint will error. All user-facing text goes through `useLocalize()` with English keys in `client/src/locales/en/translation.json`.
- **DO NOT skip package rebuilds** — changes to `data-provider`, `data-schemas`, or `packages/api` are invisible until rebuilt.
- **DO NOT iterate arrays multiple times** — message arrays are iterated frequently throughout the codebase. Consolidate into single-pass operations.
- **DO NOT add inline comments** explaining what code does — write self-documenting code instead.

#### Security Rules

- Never introduce command injection, XSS, SQL injection, or other OWASP top 10 vulnerabilities.
- `express-mongo-sanitize` is active — but do not rely on it as the only defense.
- Auth uses Passport with JWT + session strategies — respect the existing auth middleware chain.
- Validate at system boundaries (user input, external APIs) — trust internal code and framework guarantees.

#### Monorepo Gotchas

- **Workspace resolution** — `librechat-data-provider` and `@librechat/*` packages use `"*"` version in package.json (workspace protocol). Never add explicit versions for these.
- **Turbo caching** — `turbo.json` defines build inputs/outputs. If you add a new config file that affects builds, add it to `inputs`.
- **Shared dependencies** — npm overrides in root `package.json` apply globally. Check overrides before upgrading any pinned dependency.

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code
- Follow ALL rules exactly as documented
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

**For Humans:**

- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review quarterly for outdated rules
- Remove rules that become obvious over time

Last Updated: 2026-02-23
