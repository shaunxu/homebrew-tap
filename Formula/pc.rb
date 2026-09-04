class Pc < Formula
  desc "Command Line Interface for PingCode Open API"
  homepage "https://github.com/shaunxu/pingcode-cli-next"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/shaunxu/pingcode-cli-next/releases/download/v0.4.0/pc-aarch64-apple-darwin.tar.xz"
    sha256 "0ffe0a5c666c6f9d109726378f6618735bbbd528ab8b57ca2ba3f6f9786dfa29"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/shaunxu/pingcode-cli-next/releases/download/v0.4.0/pc-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e2812f3c25b837fac2e6484c82a98938712a53d2b76c7f2d2bdb4aa68809798a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "pc"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pc"
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
