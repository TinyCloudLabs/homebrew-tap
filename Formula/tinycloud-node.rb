class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.8.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "61fa34e5669ca3ab00e4cad9dd117f6c5a80d1f702738a1134938cf22a473246"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.8.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "391fb7ccea472fbce28a111d62a2155623cb2b2127718eb3ac9cb53da6d985ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.8.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17dd09fd0d738c3c8634829d4f1abfe6b2511478be6e7e0a80bf5aeab2586dfb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.8.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1820ece8d0f9f6d630ba9d66fa7a2cdf4a10e101d238bab30d5faae83b3cc228"
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
