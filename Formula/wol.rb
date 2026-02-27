class Wol < Formula
  desc "Wake On LAN functionality in a small program"
  homepage "https://ahh.sourceforge.net/"
  url "https://downloads.sourceforge.net/ahh/wol-0.7.1.tar.gz"
  sha256 "e0086c9b9811df2bdf763ec9016dfb1bcb7dba9fa6d7858725b0929069a12622"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch :p1, :DATA

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

diff --git a/lib/getline.h b/lib/getline.h
--- a/lib/getline.h
+++ b/lib/getline.h
@@ -25,12 +25,12 @@
 
 # include <stdio.h>
 
-# if __GLIBC__ < 2
+# if defined(__GLIBC__) && (__GLIBC__ < 2)
 int
 getline PARAMS ((char **_lineptr, size_t *_n, FILE *_stream));
 
 int
 getdelim PARAMS ((char **_lineptr, size_t *_n, int _delimiter, FILE *_stream));
 # endif
