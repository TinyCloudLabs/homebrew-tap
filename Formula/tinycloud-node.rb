class TinycloudNode < Formula
  desc "TinyCloud Protocol node — local-first, user-controlled cloud storage daemon"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  # TinyCloud Ecosystem General Public License (EGPL) v1.5 — not an SPDX
  # identifier. Full text: https://github.com/TinyCloudLabs/tinycloud-node/blob/main/LICENSE.md
  license :cannot_represent
  head "https://github.com/TinyCloudLabs/tinycloud-node.git", branch: "main"

  # --- Stable release block -------------------------------------------------
  # Placeholders below. TC-79 (Homebrew packaging) ships in the same PR as the
  # `tinycloud node service` / `serve` CLI surface this formula depends on.
  # Published releases as of this writing (v1.4.x) predate that CLI, so there
  # is no usable stable tarball yet. Once TC-79 merges to main and the next
  # `vX.Y.Z` tag runs through .github/workflows/release.yml, replace `version`
  # and each `sha256` below with the real release values (the release job
  # uploads one `tinycloud-node-<target>.tar.gz` per cargo-dist target — see
  # [workspace.metadata.dist] in Cargo.toml). Until then this stable block is
  # inert scaffolding; `brew install tinycloud-node` will fail to resolve a
  # bottle/tarball, and `--HEAD` (below) is the only working install path.
  version "0.0.0" # PLACEHOLDER — set to the first release tag that includes this CLI (e.g. "1.5.0")
  on_macos do
    on_arm do
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v0.0.0/tinycloud-node-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000" # PLACEHOLDER
    end
    on_intel do
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v0.0.0/tinycloud-node-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000" # PLACEHOLDER
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v0.0.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000" # PLACEHOLDER
    end
    on_intel do
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v0.0.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000" # PLACEHOLDER
    end
  end

  depends_on "rust" => :build

  # --- HEAD build (usable today) --------------------------------------------
  # `head` above intentionally targets the `main` branch (Homebrew style: head
  # specs should track the default branch, and `brew audit --strict` flags a
  # hardcoded feature-branch ref as a formula smell). Until TC-79's PR
  # (skgbafa/tc-58-node-service) merges, `main` does not yet have the
  # `tinycloud node service` / `serve --config` CLI this formula's `service do`
  # and `test do` blocks exercise.
  #
  # To validate against the feature branch *before* merge, do not edit this
  # file's head branch. Instead, test the CLI directly against the branch:
  #
  #   git clone --branch skgbafa/tc-58-node-service \
  #     https://github.com/TinyCloudLabs/tinycloud-node.git /tmp/tinycloud-node-tc79
  #   cd /tmp/tinycloud-node-tc79 && cargo build --release -p tinycloud-node
  #   /tmp/tinycloud-node-tc79/target/release/tinycloud --version
  #
  # Or, to exercise this exact formula against the branch with brew's build
  # sandbox (temporary local-only edit, never commit the branch pin):
  #
  #   sed -i '' 's/branch: "main"/branch: "skgbafa\/tc-58-node-service"/' \
  #     Formula/tinycloud-node.rb
  #   brew install --HEAD --build-from-source ./Formula/tinycloud-node.rb
  #   git checkout Formula/tinycloud-node.rb   # revert the pin before pushing
  #
  # After TC-79 merges to main, plain `brew install --HEAD tinycloud-node`
  # against this tap works with no edits.

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
    run [opt_bin/"tinycloud", "serve", "--config", "#{Dir.home}/Library/Application Support/TinyCloud Node/tinycloud.toml"]
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
