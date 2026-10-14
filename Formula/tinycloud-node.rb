class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.20.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.6/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "26ad5ec528706749bea4426b07fdaf4d6e9fabbbbcb3b77038b67aa61d3cc4a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.6/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "c5f65260a7f066a22290c2f0ba2cbf111e3a9ecef636780f68684de446b16d31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.6/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0151eb0c9766c99cbdc25b8d1c75231c6698355792f674a4824e9f379a049c38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.6/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08e4b3ac03fe79ccbe3af4d55e64eff4e07d9ee4107605de75e47ca589679627"
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
