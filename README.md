# gentoo-overlay

Ștefan Talpalaru's personal Gentoo Linux overlay.

## Installing

This overlay is available in the official Gentoo list. Add it with:

```bash
eselect repository enable stefantalpalaru guru cg
emaint sync
```

## Counting packages

`ls -Fd */* | grep '/$' | grep -Ev '^(profiles|metadata|acct-)' | wc -l`

