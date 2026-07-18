class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.1/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "44ff1f2611e8e41ca974bcf63bdb1af84cd45a68eaace70193685e6da28d15b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.1/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "08c3631ff539d2e28e82420189d21a20cd3a81cb2b771236410f13011446b256"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.1/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9f72ff5a16adf4a63202b573fe191a8e46574f5591c96f0aef3c549a8c9d059a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.6.1/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d10e57aed59e0681ac31ad5c6c63e1094618b33dbd59f72046a0fe885a8a66c5"
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
