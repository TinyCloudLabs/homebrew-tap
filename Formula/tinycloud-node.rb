class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.5.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "d9ad7cba65b40890643ced18e23e0d4528b977a873d40c8d6eb6da0cc7b4d918"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.5.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "20e3bbf43b4b0ddf21ce2bf02330a592f3ce7d8b11b75feac542e64eba46b3f7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.5.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02b36dbb1010d828f44cec4c57c0f674f8e00f5fad68e9015d6e344521e75031"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.5.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff0b5418b71ec043903cc29fc6ca8e42d87ad99f412ddedf911d497f2612f14c"
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
