class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.7.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "9784d93d17e91b9814f70a5d21dbba48758fab71580edee488891656dcae4b50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.7.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "fe8603350117c8eea8eda96a6ba589c37129859e2bc6699d409e9369a7631982"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.7.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7eba4b0bbcb1c14c2e1ec55a29a3eb1557c103331abdd3c9ed58d52783387855"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.7.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdd446eb2a34d4b73ffaf49e88ba43c24601f6faa31e60bca3f49947633d110a"
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
    bin.install "tinycloud" if OS.mac? && Hardware::CPU.arm?
    bin.install "tinycloud" if OS.mac? && Hardware::CPU.intel?
    bin.install "tinycloud" if OS.linux? && Hardware::CPU.arm?
    bin.install "tinycloud" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
