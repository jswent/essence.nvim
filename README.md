# essence.nvim

Modern Neovim plugin for syntax detection, highlighting, and concealing for the [Essence](https://conjure.readthedocs.io/en/latest/essence.html) and [Essence'](http://savilerow.cs.st-andrews.ac.uk/index.html) modelling languages.

This is a complete rewrite of [essence.vim](https://github.com/Druid-of-Luhn/essence.vim) using modern Neovim/Lua plugin development practices.

## Features

- 🎨 **Syntax Highlighting** - Complete syntax highlighting for Essence and Essence' languages
- 👁️ **Concealing Support** - Optional Unicode symbol concealing for operators (e.g., `exists` → `∃`, `forAll` → `∀`)
- 📝 **Filetype Detection** - Automatic detection for `.essence`, `.eprime`, `.param`, `.rule`, `.repr`, and more
- 💬 **Comment Support** - Proper comment string configuration for Essence's `$` comment syntax
- ⚡ **Lazy Loading** - Built with lazy.nvim compatibility in mind

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "essence.nvim",
  ft = "essence",  -- Lazy load on essence filetype
  opts = {
    conceal = false,  -- Enable Unicode concealing (default: false)
  },
}
```

````

## Configuration

### Default Configuration

```lua
require("essence").setup({
  conceal = false,  -- Enable Unicode concealing of operators
})
````

### Conceal Operators

When `conceal = true`, the following operators are concealed with Unicode symbols:

| Original    | Concealed | Description            |
| ----------- | --------- | ---------------------- |
| `exists`    | `∃`       | Existential quantifier |
| `forAll`    | `∀`       | Universal quantifier   |
| `in`        | `∈`       | Set membership         |
| `intersect` | `∩`       | Set intersection       |
| `lambda`    | `λ`       | Lambda                 |
| `subset`    | `⊂`       | Proper subset          |
| `subsetEq`  | `⊆`       | Subset or equal        |
| `sum`       | `∑`       | Summation              |
| `supset`    | `⊃`       | Proper superset        |
| `supsetEq`  | `⊇`       | Superset or equal      |
| `union`     | `∪`       | Set union              |
| `*`         | `×`       | Multiplication         |
| `!`         | `¬`       | Logical NOT            |
| `->`        | `⇒`       | Implication            |
| `<->`       | `⇔`       | Bi-implication         |
| `!=`        | `≠`       | Not equal              |
| `<=`        | `≤`       | Less than or equal     |
| `>=`        | `≥`       | Greater than or equal  |
| `/\`        | `∧`       | Logical AND            |
| `\/`        | `∨`       | Logical OR             |
| `-->`       | `→`       | Arrow                  |

**Note:** Concealing requires UTF-8 encoding and a font with Unicode symbol support.

## Filetype Detection

The plugin automatically detects Essence files based on:

1. **File Extensions:**
   - `.essence`
   - `.eprime`
   - `.param`
   - `.rule`
   - `.repr`
   - `.solution`
   - `.essence.out`
   - `.essence.log`
   - `.essence.err`

2. **File Content:**
   - Files beginning with `language Essence` or `language ESSENCE`

## Syntax Highlighting

The plugin provides syntax highlighting for:

- **Keywords:** `be`, `branching`, `by`, `domain`, `exists`, `find`, `forAll`, `given`, `in`, `letting`, `maximising`, `minimising`, `such`, `that`, `where`, etc.
- **Kinds:** `bool`, `enum`, `function`, `int`, `matrix`, `mset`, `partition`, `relation`, `set`, `tuple`
- **Types:** `bijective`, `complete`, `injective`, `partial`, `total`, `size`, `minSize`, `maxSize`, etc.
- **Functions:** `allDiff`, `and`, `or`, `max`, `min`, `sum`, `product`, `flatten`, `toSet`, `toMSet`, etc.
- **Operators:** Arithmetic (`+`, `-`, `*`, `/`, `%`, `^`), Logical (`!`, `->`, `<->`, `/\`, `\/`), Comparison (`=`, `!=`, `<`, `>`, `<=`, `>=`)
- **Comments:** Lines starting with `$`
- **Numbers and Booleans**
- **conjureLog:** Special highlighting for Conjure log output

## Credits

- Original [essence.vim](https://github.com/Druid-of-Luhn/essence.vim) by Billy Brown
- Concealing code adapted from [Bilalh/Essence-Syntax-Highlighting](https://github.com/Bilalh/Essence-Syntax-Highlighting)
