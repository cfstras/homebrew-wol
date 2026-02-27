class Wol < Formula
  desc "Wake On LAN functionality in a small program"
  homepage "https://ahh.sourceforge.net/"
  url "https://downloads.sourceforge.net/ahh/wol-0.7.1.tar.gz"
  sha256 "e0086c9b9811df2bdf763ec9016dfb1bcb7dba9fa6d7858725b0929069a12622"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch :p1 do
    url "https://raw.githubusercontent.com/cfstras/homebrew-wol/main/build-fix.patch"
    sha256 "21d89b05705db671c091ac94aa2f53a26c058ff7b3ad30a2ab73954b13508a43"
  end

  patch :p2 do
    url "https://raw.githubusercontent.com/cfstras/homebrew-wol/main/interface-select.patch"
    sha256 "e8b6205f8afb5d3f9d70ded2f8af13a04c6294fc20a547eb5c522bbc2d0cb7f9"
  end

  def install
    system "autoreconf", "-fiv"

    system "./configure",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--mandir=#{man}"

    # Mirror the config.h adjustments from the Arch Linux PKGBUILD.
    # Homebrew's `inreplace` helper is intentionally strict (it errors if a
    # replacement doesn't match). On macOS, some of these lines may simply not
    # exist, so do a best-effort edit instead.
    config_h = File.read("config.h")
    config_h.gsub!("HAVE_ETHER_HOSTTON 0", "HAVE_ETHER_HOSTTON 1")
    config_h.gsub!("HAVE_STRUCT_ETHER_ADDR 0", "HAVE_STRUCT_ETHER_ADDR 1")
    config_h.gsub!(
      "HAVE_STRUCT_ETHER_ADDR_ETHER_ADDR_OCTET 0",
      "HAVE_STRUCT_ETHER_ADDR_ETHER_ADDR_OCTET 1",
    )
    # Arch's PKGBUILD drops any gnulib "replacement" mappings (e.g. "#define malloc rpl_malloc").
    # On macOS these can cause link errors if the replacement symbols are not built.
    config_h = config_h.lines.reject { |line| line.include?("rpl_") }.join
    File.write("config.h", config_h)

    ENV.append_to_cflags "-DSTDC_HEADERS=1"

    system "make"
    system "make", "install"
  end

  test do
    system bin/"wol", "--help"
  end
end
