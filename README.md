# wol-brew

Homebrew tap providing a single formula: `wol` (Wake-on-LAN CLI).

## Install

If you publish this repo on GitHub (recommended):

- For the short form `brew tap <user>/<repo>`, Homebrew expects the GitHub repo to be named `homebrew-<repo>`.
	For example: create `github.com/<user>/homebrew-wol-brew`, then run:

```sh
brew tap <your-github-user>/wol-brew
brew install wol
```

For local testing from a checkout (before publishing):

```sh
git init
git add .
git commit -m "Initial tap"

brew tap https://github.com/cfstras/wol-brew
brew install wol
```

## Notes

- This formula builds `wol` from the upstream SourceForge release and applies the same build fix used by the Arch Linux PKGBUILD in this repo.
