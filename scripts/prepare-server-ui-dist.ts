import { spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, "..");
const uiDist = path.join(repoRoot, "ui", "dist");
const serverUiDist = path.join(repoRoot, "server", "ui-dist");

const pnpmBin = process.platform === "win32" ? "pnpm.cmd" : "pnpm";

console.log("  -> Building @paperclipai/ui...");
const buildResult = spawnSync(pnpmBin, ["--dir", repoRoot, "--filter", "@paperclipai/ui", "build"], {
  stdio: "inherit",
  shell: process.platform === "win32",
});

if (buildResult.status !== 0) {
  console.error("Error: UI build failed");
  process.exit(buildResult.status ?? 1);
}

if (!existsSync(path.join(uiDist, "index.html"))) {
  console.error(`Error: UI build output missing at ${path.join(uiDist, "index.html")}`);
  process.exit(1);
}

await fs.rm(serverUiDist, { recursive: true, force: true });
await fs.cp(uiDist, serverUiDist, { recursive: true });

console.log("  -> Copied ui/dist to server/ui-dist");
