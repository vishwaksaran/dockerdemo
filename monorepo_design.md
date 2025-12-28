# Legacy Monorepo Architecture: Project "TimeCapsule"

This document outlines the architecture, structure, and known issues of the "TimeCapsule" monorepo. This system represents a transitional state between a legacy Angular 2.x application and a modern React migration, heavily constrained by Node.js version compatibility.

## 1. Repository Structure

The repository follows a unified monorepo structure with a shared root for dependency management (a common pattern in early migration phases before workspace separation).

```text
/
├── angular/                  # [LEGACY] Angular 2.x Application
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/   # Legacy components (approx 40 remaining)
│   │   │   ├── services/     # Shared business logic services
│   │   │   └── models/       # Shared TypeScript interfaces
│   │   ├── main.ts           # Angular bootstrap
│   │   └── polyfills.ts      # Browser polyfills (core-js, zone.js)
│   ├── tsconfig.json         # Legacy TypeScript 2.x config
│   └── webpack.config.js     # Custom Webpack 2/3 configuration
│
├── react/                    # [MODERN] React 16.x Application
│   ├── public/
│   ├── src/
│   │   ├── v2/               # Migrated components (10 converted)
│   │   ├── adapters/         # angular2react wrappers
│   │   ├── App.tsx
│   │   └── index.tsx
│   ├── package.json          # React-specific scripts (dev, build)
│   └── tsconfig.json         # Modern(ish) TypeScript config
│
├── .nvmrc                    # Enforces Node v10.x (CRITICAL)
├── package.json              # ROOT dependencies (Conflict Zone)
├── tsconfig.json             # Base TS config
└── README.md
```

## 2. Failure Analysis & Node.js Incompatibility

The system is currently effectively "frozen" on **Node 10.x**. Upgrading to Node 12+ (and especially 16/18) causes immediate catastrophic failure in the Angular layer.

### Why Angular Breaks (Node 16+ Upgrade)

| Component | Failure Reason | Symptoms |
|-----------|----------------|----------|
| **node-sass** | The legacy Angular app relies on `node-sass` (compiled C++ bindings). Old versions of `node-sass` are binary-incompatible with Node 16+. | `Error: Node Sass does not yet support your current environment: Windows 64-bit with Unsupported runtime` |
| **Webpack 3** | Uses `crypto` hashing algorithms that may be deprecated or handled differently in newer Node crypto APIs (OpenSSL 3 in Node 17+). | `Error: error:0308010C:digital envelope routines::unsupported` |
| **RxJS 5** | Heavy usage of patched operators incompatible with stricter modern TS typing and newer execution contexts. | Runtime errors or build failures with modern Typescript. |
| **Angular CLI** | If present, old `ng` commands use internal FS APIs that changed in Node 12/14. | `ReferenceError: primordials is not defined` (classic Node 10->12+ breaking change in `graceful-fs`). |

### Why React Keeps Working

The React application is structured to be resilient:
1. **Newer Dependency Stack**: Even though it shares the root `node_modules`, the React build scripts (likely `react-scripts` or a newer Webpack 4/5 config local to the `react/` folder or aliased) use pure JS implementations (like `sass` instead of `node-sass`) where possible.
2. **Standardization**: React 16.8+ (Hooks) runs on standard JS that doesn't rely on fragile binary bindings typically found in the era of Angular 2.
3. **Isolation**: The migrated components in `react/v2` are pure view layers. They might consume data models, but they don't depend on the Angular dependency injection system or `zone.js` for their build process.

## 3. Migration Strategy (The "Strangler Fig" Pattern)

This repo represents a "Strangler Fig" migration in progress.

- **Current State**: ~20% Migrated (10/50 Components).
- **Strategy**: 
    1. **angular2react**: We use this library to wrap Angular components inside React or vice-versa to allow incremental adoption. 
    2. **Side-by-Side**: Both apps run. We might be serving the React app for specific routes or embedding it.
- **The Blockage**: We cannot update the core infrastructure (TypeScript, Webpack) because it breaks Angular. We cannot finish the migration fast enough to simply delete Angular.
- **The Debt**: We are paying a "tax" of being stuck on Node 10. Security vulnerabilities in old generic packages cannot be patched easily because strictly newer versions drop support for Node 10.

## 4. Setup Instructions (for "broken" simulation)

1. **Success Path**: 
   - Install Node 10.16.0 (`nvm use 10`)
   - `npm install`
   - `npm run start:angular` (Works)
   - `npm run start:react` (Works)

2. **Failure Path**:
   - Install Node 16.x (`nvm use 16`)
   - `npm install` -> **FAIL** (node-sass compilation error)
   - *If forced* (`npm install --ignore-scripts`), then `npm run start:angular` -> **FAIL** (OpenSSL/Webpack error).
   - `npm run start:react` -> **WORKS** (mostly, barring shared dep issues).
