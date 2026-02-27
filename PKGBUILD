# Maintainer: Sergej Pupykin <pupykin.s+arch@gmail.com>
# Contributor: Anders Bergh <anders1@gmail.com>
# Contributor: Markus Volkmann <mcfock@counterstrike.de>

pkgname=wol
pkgver=0.7.1
pkgrel=11
arch=('x86_64')
pkgdesc="Wake On LAN functionality in a small program. It wakes up hardware that is Magic Packet compliant"
license=("GPL-2.0-only")
url="http://ahh.sourceforge.net/wol/"
validpgpkeys=('9484D99D2E1E4E025446DAD9FF584E5967A1DA7B')
source=(https://downloads.sourceforge.net/ahh/wol-$pkgver.tar.gz{,.asc}
	"build-fix.patch")
sha256sums=('e0086c9b9811df2bdf763ec9016dfb1bcb7dba9fa6d7858725b0929069a12622'
            'SKIP'
            'a9677b9b9d4431c4cab1e9b2a2e9601e4cad4d8f30425484a81bd802d81c1225')

prepare() {
  cd "$srcdir"/$pkgname-$pkgver
  patch -p1 -i "$srcdir"/build-fix.patch
}


build() {
  cd "$srcdir"/$pkgname-$pkgver
  autoreconf -fiv
  ./configure \
    --prefix=/usr \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info
  sed -i \
    -e 's|HAVE_ETHER_HOSTTON 0|HAVE_ETHER_HOSTTON 1|' \
    -e 's|HAVE_STRUCT_ETHER_ADDR 0|HAVE_STRUCT_ETHER_ADDR 1|' \
    -e 's|HAVE_STRUCT_ETHER_ADDR_ETHER_ADDR_OCTET 0|HAVE_STRUCT_ETHER_ADDR_ETHER_ADDR_OCTET 1|' \
    -e '/rpl_/d' \
    config.h
  make CFLAGS="$CFLAGS -DSTDC_HEADERS=1"
}

package() {
  cd "$srcdir"/$pkgname-$pkgver
  make DESTDIR="$pkgdir" install
  rm "$pkgdir"/usr/share/info/dir
}
