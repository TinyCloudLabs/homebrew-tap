class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.11.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "911d9f358f418d7279ec91fa037200d8c23c4aa007b7262c2551e390fe8da9a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.11.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "053a03968cc94123d65265d1a6a6b73bcc1828f990517006f8de95157c330c3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.11.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ee28092ba792a0a77d371ea0a2185993e7f1d2a4c43b6689b53bd8529764a84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.11.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "316ddfea820ce8fc115cca8992eea8c2e67ea1a36703b4dd7870a272c3905a5f"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "export-share-invitation-descriptor", "tinycloud" if OS.mac? && Hardware::CPU.arm?
    bin.install "export-share-invitation-descriptor", "tinycloud" if OS.mac? && Hardware::CPU.intel?
    bin.install "export-share-invitation-descriptor", "tinycloud" if OS.linux? && Hardware::CPU.arm?
    bin.install "export-share-invitation-descriptor", "tinycloud" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
