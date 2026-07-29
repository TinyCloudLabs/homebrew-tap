class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.13.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "2b5e43214faa45de6ad2a1e51a53a660092ed14a65cfb9e0d51f8cbac30c8643"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.13.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "8c08ec4e64f38b430a0ab47f3a1f9a2f75ab82587a5eecfc3ee959c01edd15f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.13.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "546f4dd4eb67175a204d80335157a77524d21cfa7f70c2dd9b89fd953c0e638c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.13.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cf223740d87b85c36a497691540b30afa078dd411c297c57a3df85e729d4666d"
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
