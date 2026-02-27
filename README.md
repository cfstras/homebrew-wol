# wol-brew

Homebrew tap providing a single formula: `wol` (Wake-on-LAN CLI).

## Install

Installing:
```sh
brew tap cfstras/wol
brew install wol
```

For local testing from a checkout (before publishing):

## Notes

This formula builds `wol` from the upstream SourceForge release and was converted and amended from the Arch package [wol](https://archlinux.org/packages/extra/x86_64/wol/).

To send magic packets from a specific interface, use `-I/--interface`:

```sh
# macOS example
wol -I en0 00:11:22:33:44:55

# You can also pass a local IPv4 address to bind the source address
wol -I 192.168.1.10 00:11:22:33:44:55
```
