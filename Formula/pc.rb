class Pc < Formula
  desc "Command Line Interface for PingCode Open API"
  homepage "https://github.com/shaunxu/pingcode-cli-next"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/shaunxu/pingcode-cli-next/releases/download/v1.0.0/pc-aarch64-apple-darwin.tar.xz"
    sha256 "53704d371315c27885edfdfa30ac955eac81b070573a93b95f3178f4660a9c88"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/shaunxu/pingcode-cli-next/releases/download/v1.0.0/pc-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "523c27e2502c49ec931bafb0db5b4fa239de34db5b7241a44de42ed89c84c91b"
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
