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
      // Ring the terminal bell on session completion
      if (event.type === "session.idle") {
        // await ringBell()
        process.stdout.write("\x07")
      }
    },
  }
}