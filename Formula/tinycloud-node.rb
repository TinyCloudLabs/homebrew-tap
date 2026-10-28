class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.25.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.25.10/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "70c01675c04f703a770105308a2161d0d9f803320944412234345015b515284d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.25.10/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "506fb5c02ec416cb1aafa0743ff0adf3e2d55d556da94f50b3600ec9cdfd8399"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.25.10/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28e0160fbe383b94b1de54291431b9205f1e17e5bb4f27814c32271b160d4706"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.25.10/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d7e5556b6033c73abaa53247b1dbc13bdecea116b93bac17fcb8492cc31b30d"
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
