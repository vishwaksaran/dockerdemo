console.log("Running legacy environment checks...");
console.warn("WARNING: This project requires Node 10.x. Current version: " + process.version);
if (!process.version.startsWith('v10.')) {
  console.error("CRITICAL FAILURE: Incompatible Node version detected. Angular build will fail.");
  // In a real scenario, this might exit process.exit(1), but we want to simulate the failure naturally during install/build
}
