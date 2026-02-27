class Wol < Formula
  desc "Wake On LAN functionality in a small program"
  homepage "https://github.com/cfstras/wol"
  url "https://github.com/cfstras/wol.git",
      tag:      "v0.7.1",
      revision: "6a318e45d41f683e5203ad7b7b8fc3e85de184a8"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
