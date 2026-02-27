class Wol < Formula
  desc "Wake On LAN functionality in a small program"
  homepage "http://ahh.sourceforge.net/wol/"
  url "https://downloads.sourceforge.net/ahh/wol-0.7.1.tar.gz"
  sha256 "e0086c9b9811df2bdf763ec9016dfb1bcb7dba9fa6d7858725b0929069a12622"
  license "GPL-2.0-only"

  patch :p1, :DATA

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
    inreplace "config.h" do |s|
      s.gsub! "HAVE_ETHER_HOSTTON 0", "HAVE_ETHER_HOSTTON 1"
      s.gsub! "HAVE_STRUCT_ETHER_ADDR 0", "HAVE_STRUCT_ETHER_ADDR 1"
      s.gsub! "HAVE_STRUCT_ETHER_ADDR_ETHER_ADDR_OCTET 0", "HAVE_STRUCT_ETHER_ADDR_ETHER_ADDR_OCTET 1"
      s.gsub!(/^#define rpl_.*\n/, "")
    end

    ENV.append_to_cflags "-DSTDC_HEADERS=1"

    system "make"
    system "make", "install"
  end

  test do
    # wol prints usage/help and exits successfully for -h on most builds.
    system bin/"wol", "-h"
  end
end

__END__
diff --git a/lib/realloc.c b/lib/realloc.c
--- a/lib/realloc.c
+++ b/lib/realloc.c
@@ -24,8 +24,12 @@
 
 #include <sys/types.h>
 
-char *malloc ();
-char *realloc ();
+#if STDC_HEADERS
+# include <stdlib.h>
+#else
+void *malloc ();
+void *realloc ();
+#endif
 
 /* Change the size of an allocated block of memory P to N bytes,
  with error checking.  If N is zero, change it to 1.  If P is NULL,
