// Reloads any Helix (hx) pane in the current Herdr workspace after pi edits
// a file on disk, so the editor buffer doesn't go stale.
// Logic lives in one shared script also used by Claude Code's PostToolUse
// hook: ~/personal/.dotfiles/herdr/reload-helix.sh

import { execFile } from "node:child_process";

const RELOAD_SCRIPT = "/Users/dima/personal/.dotfiles/herdr/reload-helix.sh";
const FILE_TOOLS = new Set(["edit", "write"]);

export default function (pi) {
  pi.on("tool_execution_end", (event) => {
    if (!FILE_TOOLS.has(event?.toolName)) return;
    if (event?.isError) return;
    execFile("bash", [RELOAD_SCRIPT], () => {});
  });
}
