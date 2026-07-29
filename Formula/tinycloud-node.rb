class TinycloudNode < Formula
  desc "TinyCloud Protocol Node"
  homepage "https://github.com/TinyCloudLabs/tinycloud-node"
  version "1.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.12.0/tinycloud-node-aarch64-apple-darwin.tar.xz"
      sha256 "e755fb9f598c5ea68f56b36f1e9a6092d4e0006b7ae153481b117578c876d231"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.12.0/tinycloud-node-x86_64-apple-darwin.tar.xz"
      sha256 "898179737b710e2eb9ce345ad9d514796ebad301fa35e8e5b3fdf54c915c10e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.12.0/tinycloud-node-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8e6a8dbad9e7a9f957cd19d5b1430dcaacbe61a09f1246055e6bdabb22b558c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyCloudLabs/tinycloud-node/releases/download/v1.12.0/tinycloud-node-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b54b9ca1890e8ba5681ba9b4a3cde5f9cdd08cd4aaeda95cd695e76537ae8bb6"
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
