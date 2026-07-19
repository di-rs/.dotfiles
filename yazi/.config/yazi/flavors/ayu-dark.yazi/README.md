# ayu-dark.yazi

Ayu Dark flavor for [Yazi](https://yazi-rs.github.io), hand-authored to match
ghostty's built-in **Ayu** theme — and helix `ayu_dark`, hunk `ayu-dark`, pi
`ayu-dark` — so the file manager stays in sync with the rest of the setup.

Vendored on purpose. It lives in this repo instead of being fetched with
`ya pkg`, so stow gives a working theme with no extra install step. The
community `kmlupreti/ayu-dark` flavor targets an older schema
(`[select]`/`[completion]` rather than `[pick]`/`[cmp]`) and renders wrong on
current Yazi; this one is written against the 26.x schema.

- `flavor.toml` — UI colors. Schema: <https://yazi-rs.github.io/schemas/theme.json>
- `tmtheme.xml` — syntax highlighting for the file preview.

Palette (from ghostty's Ayu theme): bg `#0b0e14` · fg `#bfbdb6` ·
accent `#e6b450` · blue `#59c2ff` · green `#aad94c` · yellow `#ffb454` ·
red `#f07178` · magenta `#d2a6ff` · cyan `#95e6cb`.
