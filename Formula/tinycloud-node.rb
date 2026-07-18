class TinycloudNode < Formula
  desc "TinyCloud Protocol node — local-first, user-controlled cloud storage daemon"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  # TinyCloud Ecosystem General Public License (EGPL) v1.5 — not an SPDX
  # identifier. Full text: https://github.com/TinyCloudLabs/tinycloud-node/blob/main/LICENSE.md
  license :cannot_represent
  head "https://github.com/TinyCloudLabs/tinycloud-node.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tinycloud-node-server")
  end

  # `brew services` integration is a fallback for users who manage services
  # via `brew services start/stop/restart tinycloud-node`. The CLI's own
  # `tinycloud node service install|start|stop|status|uninstall` (a real
  # launchd LaunchAgent on macOS, systemd unit on Linux) is the primary,
  # documented way to run this as a service — see docs/specs/node-control-plane-v1.md.
  # This block mirrors what `tinycloud node service install` generates so the
  # two paths stay behaviorally equivalent, but installs/manages the plist via
  # Homebrew's service manager instead of the CLI's own launchd/systemd calls.
  service do
    config_path = "#{Dir.home}/Library/Application Support/TinyCloud Node/tinycloud.toml"
    run [opt_bin/"tinycloud", "serve", "--config", config_path]
    keep_alive true
    log_path var/"log/tinycloud-node.log"
    error_log_path var/"log/tinycloud-node.err.log"
  end

  test do
    assert_match "tinycloud", shell_output("#{bin}/tinycloud --version")

    # Sanity check the JSON contract shape without a real install: with no
    # service installed, `service status --json` must still succeed and
    # report state "not-installed" (see docs/specs/node-control-plane-v1.md §3.3).
    require "json"
    status = JSON.parse(shell_output("#{bin}/tinycloud node service status --json"))
    assert_equal "not-installed", status["state"]
  end
end
