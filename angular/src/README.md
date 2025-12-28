# Legacy Angular App Source

This is the source code for the legacy Angular 2.x application. 

**WARNING**: significant portions of this codebase rely on:
- Global `zone.js` patching (conflicts with modern async/await in some edge cases)
- `node-sass` bindings (fails on Node 14+)
- Webpack 2/3 custom loaders

## Remaining Components: ~40

The migration strategy is to move "leaf" components (dumb UI components) to `react/v2` first, then work upwards to smart containers.
