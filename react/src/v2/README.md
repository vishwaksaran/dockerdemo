# Migrated Components (v2)

This directory contains React components that have been fully converted from their Angular counterparts using `angular2react` or rewritten from scratch.

## Status: 10 / 50 Components Migrated

| Component | Original Angular Path | Status |
|-----------|-----------------------|--------|
| UserProfileCard | `angular/.../user-profile.component.ts` | ✅ Done |
| Header | `angular/.../header.component.ts` | ✅ Done |
| Sidebar | `angular/.../sidebar.component.ts` | ✅ Done |
| ... | ... | ... |

These components are designed to be consumed by BOTH the new React app and the legacy Angular app (via `react2angular` adapter pattern, if applicable, though currently we focus on the React app consuming them).
