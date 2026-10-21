class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.21.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.21.6/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "39e556832e44ff5894f830507dc265689684b381ae44d7db3eb8281b5f81e96a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.21.6/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "e011a167ecd404068d1b66bb1baf11bd5f8cc1bf467dc07f28856390643854c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.21.6/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1852fd2b1c6cc79c18d9e415fa86ef0c50e89fd2b182b34c3fa30a5be381f2b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.21.6/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e1fa9bde5de56add82cd44728c96975ebeaa60765561ef24aa086b84b0acf5d5"
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
      bin.install "export-share-invitation-descriptor", "tinycloud", "tinycloud-sql-identity"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "export-share-invitation-descriptor", "tinycloud", "tinycloud-sql-identity"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "export-share-invitation-descriptor", "tinycloud", "tinycloud-sql-identity"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "export-share-invitation-descriptor", "tinycloud", "tinycloud-sql-identity"
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
