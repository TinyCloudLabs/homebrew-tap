class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.10.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "e65afd684bce6b6e0f08f5d049e0afb69c6473ff4019b2ac7ca9c2381f0f660c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.10.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "9a81b84b408e0201a991d0ad2d1bab9d23fa118a1c8addd752fcc090d56a1c3d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.10.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "180561c91428dcc4f89eb756be4c1d137f3251ff2f14f4b6799fd13613e1ddc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.10.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e243074b0d208913220d7aca95b727b3014c687851e7af57c13cc418d9fe9ab"
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
