class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.26.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.26.23/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "7ee01f4ff6f09953f4ffe78678197b637ba4e97ca820141bcde38352433925b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.26.23/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "b75112cccd204fab1b140ed9aee85bebdad898b70ba0c567746a79f28c7fce62"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.26.23/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc466bef92fbd7edc5f1f881aafb86f5408b4a32909778710517014761739dd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.26.23/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d3dec14b6b8b0c7a80c455383e2ed930070dc8528163d5f321d32d768b0526d0"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "export-share-invitation-descriptor", "tc971-static-identity", "tinycloud", "tinycloud-sql-identity"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "export-share-invitation-descriptor", "tc971-static-identity", "tinycloud", "tinycloud-sql-identity"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "export-share-invitation-descriptor", "tc971-static-identity", "tinycloud", "tinycloud-sql-identity"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "export-share-invitation-descriptor", "tc971-static-identity", "tinycloud", "tinycloud-sql-identity"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
