let lastBellTime = 0
const BELL_DEBOUNCE_MS = 500

function ringBell(now = Date.now()) {
  if (!process.stdout.isTTY) {
    return Promise.resolve()
  }

  if (now - lastBellTime < BELL_DEBOUNCE_MS) {
    return Promise.resolve()
  }

  lastBellTime = now

  return new Promise((resolve) => {
    process.stdout.write("\x07", () => {
      resolve()
    })
  })
}

export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      // ring the terminal bell when requiring attention
      // https://github.com/anomalyco/opencode/blob/b9f3b382fcfd82b57103b29b77572f112ce9e1e5/packages/web/src/content/docs/plugins.mdx#events
      if (event.type === "session.status" ) {
        // await ringBell()
        process.stdout.write("\x07")
      }
    },
  }
}