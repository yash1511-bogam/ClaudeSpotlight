export const DOWNLOAD_URL = "https://github.com/yash1511-bogam/ClaudeSpotlight/releases/download/v1.0.0/ClaudeSpotlight-v1.0.0-macOS.zip"
export const DOWNLOAD_SHA256 = "bc30941d60d62b509e08552b121b2448919bd72a747aa7ccb61428d43c4f8713"

export function handleDownload() {
  const isMac = /Mac|Macintosh/.test(navigator.userAgent)
  if (!isMac) {
    alert("ClaudeSpotlight is only available for macOS 15.0+ (Sequoia). Your operating system is not supported.")
    return
  }
  window.open(DOWNLOAD_URL, "_blank")
}
