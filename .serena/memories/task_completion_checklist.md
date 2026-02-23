# Task Completion Checklist

When completing a task, ensure:

1. **Type Safety**: No `any` types, all TS/ESLint warnings resolved
2. **Build Check**: If data-provider was modified, run `npm run build:data-provider`
3. **Test**: Run relevant workspace tests (`cd <workspace> && npx jest <pattern>`)
4. **Lint**: Ensure no ESLint errors (`npx eslint <changed-files>`)
5. **Format**: All formatting lint errors fixed (trailing spaces, tabs, newlines, indentation)
6. **Workspace Boundaries**:
   - New backend code is TypeScript in `/packages/api`
   - `/api` changes are minimal JS wrappers
   - Shared types/endpoints in `/packages/data-provider`
   - Database schemas in `/packages/data-schemas`
7. **Frontend**: User-facing text uses `useLocalize()`, only English translations updated
8. **Performance**: No unnecessary loops, efficient data structures, proper dependency arrays
9. **No over-engineering**: Only changes directly requested or clearly necessary
