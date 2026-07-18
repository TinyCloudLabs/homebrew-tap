class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "dd19d4563df66d9e81e7544be4933e65281b65c40ead8aaad704b52348c69371"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "95df139c7e39dc7ae4ca0cdfc699175f259be0324f886f24d07c0c108cb3cc72"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e78b398622ed489ba8144f4e8dabebc435dd23257ea76bd604ae38aa7aaef0f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4dc257ec6c37a3dd08b3531cea2f4690c350deb1e64a73bb521a4b8d4e3f256c"
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
