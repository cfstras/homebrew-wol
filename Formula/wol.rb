class Wol < Formula
  desc "Wake On LAN functionality in a small program"
  homepage "https://github.com/cfstras/wol"
  url "https://github.com/cfstras/wol.git",
      tag:      "v0.7.1",
      revision: "6a318e45d41f683e5203ad7b7b8fc3e85de184a8"
  license "GPL-2.0-only"
  head "https://github.com/cfstras/wol.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "texinfo" => :build

  def install
    ENV.prepend_path "PATH", Formula["gettext"].opt_bin

    system "autoreconf", "-fiv"

    system "./configure",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--mandir=#{man}"

    ENV.append_to_cflags "-DSTDC_HEADERS=1"

    system "make"
    system "make", "install"
  end

  test do
    system bin/"wol", "--help"
  end
end
