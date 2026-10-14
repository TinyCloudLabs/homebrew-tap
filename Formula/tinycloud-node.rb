class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.20.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.5/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "537e1315996d3973237ad5e19a6d501a94a64bd8fe2d6450aeb8a0a7b03371e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.5/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "ecfd5ed8cf71260f294802704fb14695a7c6a031064c9352609d3d1d6ffbff59"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.5/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab373938770df77ac2e4ff6b62aa560e98da13894ffbfc3ff6c96c44627e96bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.20.5/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "26b2d922b5c83bbcada13cd5ad712aae39388da9f931671560cb64067ce19ca5"
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
