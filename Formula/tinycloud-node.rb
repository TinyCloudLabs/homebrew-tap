class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.15.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "4ab59dc744f786e377a4e63207e3b409af32a740e163db574c81aad1efcea6d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.15.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "92ee68a2ea3fa2ef19bde218ce140061b438ea83ecedf02b7ba1630e7583b661"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.15.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "801bbee23b0862407717c81565a5730970712b5c8b235da65ad565832870a330"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.15.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1250b993cf1547757b8737242ed6498394f68d0cf8d019ff5fe12ffda4c39b5e"
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
