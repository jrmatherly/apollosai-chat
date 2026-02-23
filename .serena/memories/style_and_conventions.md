# Code Style & Conventions

## General Principles
- **Never-nesting**: early returns, flat code, minimal indentation
- **Functional first**: pure functions, immutable data, map/filter/reduce over imperative loops
- **No `any` types**: explicit types for all parameters, return values, variables
- **Limit `unknown`**: avoid `Record<string, unknown>` and `as unknown as T`
- **DRY**: extract repeated logic, reusable hooks, parameterized helpers

## Formatting (Prettier)
- Print width: 100
- Tab width: 2 (spaces, no tabs)
- Single quotes, trailing commas (all), semicolons
- Arrow parens: always
- Plugin: prettier-plugin-tailwindcss

## Import Order
1. Package imports — shortest to longest line
2. `import type` — longest to shortest (package types first, then local)
3. Local imports — longest to shortest
- Always use standalone `import type { ... }` (never inline)

## Comments
- Self-documenting code preferred
- JSDoc only for complex/non-obvious logic
- No inline `//` comments narrating what code does

## Loop Preferences
- Minimize looping; single-pass transformations preferred
- `for (let i = 0; ...)` for performance-critical/index-dependent
- `for...of` for simple array iteration
- `for...in` only for object property enumeration
- Use Map/Set for lookups instead of Array.find/includes

## Frontend Specifics
- All user-facing text: `useLocalize()` hook
- Only update English keys in `client/src/locales/en/translation.json`
- Semantic key prefixes: `com_ui_`, `com_assistants_`, etc.
- TypeScript for all React components with proper type imports
- Semantic HTML with ARIA labels for accessibility
- React Query for all API interactions
- QueryKeys/MutationKeys in `packages/data-provider/src/keys.ts`

## Backend Rules
- All new backend code must be TypeScript in `/packages/api`
- Keep `/api` changes minimal (thin JS wrappers)
- Database schemas in `/packages/data-schemas`
