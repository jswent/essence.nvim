# essence.nvim

Modern Neovim plugin for syntax detection, highlighting, and concealing for the [Essence](https://conjure.readthedocs.io/en/latest/essence.html) and [Essence'](http://savilerow.cs.st-andrews.ac.uk/index.html) modelling languages.

This is a complete rewrite of [essence.vim](https://github.com/Druid-of-Luhn/essence.vim) using modern Neovim/Lua plugin development practices.

## Features

- 🎨 **Syntax Highlighting** - Complete syntax highlighting for Essence and Essence' languages
- 👁️ **Concealing Support** - Optional Unicode symbol concealing for operators (e.g., `exists` → `∃`, `forAll` → `∀`)
- 🔄 **Toggle API** - Comprehensive API for toggling concealment per-buffer or globally
- 📝 **Filetype Detection** - Automatic detection for `.essence`, `.eprime`, `.param`, `.rule`, `.repr`, and more
- 💬 **Comment Support** - Proper comment string configuration for Essence's `$` comment syntax
- ⚡ **Lazy Loading** - Built with lazy.nvim compatibility in mind

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "jswent/essence.nvim",
  ft = "essence",  -- Lazy load on essence filetype
  opts = {
    conceal = false,  -- Enable Unicode concealing (default: false)
  },
}
```

## Configuration

### Default Configuration

```lua
require("essence").setup({
  conceal = false,  -- Enable Unicode concealing of operators
})
```

### Concealing

#### Conceal Operators

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

#### Toggling Concealment

essence.nvim provides a comprehensive API for toggling concealment both per-buffer and globally:

##### User Commands

```vim
" Buffer-local commands (affect current buffer only)
:EssenceConcealToggle        " Toggle concealment for current buffer
:EssenceConcealEnable        " Enable concealment for current buffer
:EssenceConcealDisable       " Disable concealment for current buffer

" Global commands (affect all essence buffers)
:EssenceConcealToggleGlobal  " Toggle concealment globally
:EssenceConcealEnableGlobal  " Enable concealment globally
:EssenceConcealDisableGlobal " Disable concealment globally

" Status command
:EssenceConcealStatus        " Show concealment status for current buffer
```

##### Lua API

```lua
local essence = require("essence")

-- Buffer-local API (nil or bufnr parameter)
essence.conceal_enable()           -- Enable for current buffer
essence.conceal_enable(bufnr)      -- Enable for specific buffer
essence.conceal_disable()          -- Disable for current buffer
essence.conceal_toggle()           -- Toggle for current buffer
essence.conceal_is_enabled()       -- Check if enabled for current buffer

-- Global API (affects all essence buffers)
essence.conceal_enable_global()    -- Enable globally
essence.conceal_disable_global()   -- Disable globally
essence.conceal_toggle_global()    -- Toggle globally

-- Status API
local status = essence.conceal_status()
-- Returns: {
--   enabled = true/false,              -- Whether concealment is enabled
--   has_buffer_override = true/false,  -- Whether buffer has local override
--   global_setting = true/false,       -- Global config setting
--   conceallevel = 0-2,                -- Current conceallevel
--   has_support = true/false,          -- Whether concealing is supported
-- }
```

##### Keybindings (Example)

You can create custom keybindings for easy toggling:

```lua
-- In your init.lua or after/ftplugin/essence.lua
vim.keymap.set('n', '<leader>ec', function()
  require('essence').conceal_toggle()
end, { desc = 'Toggle essence concealment', buffer = true })
```

##### Per-Buffer vs Global Settings

- **Global Setting**: Set via `setup({ conceal = true })` or `:EssenceConcealEnableGlobal`
- **Buffer Override**: Use buffer-local commands/API to override global setting for specific buffers
- **Priority**: Buffer-local settings always take precedence over global settings
- **New Buffers**: Automatically inherit the global setting unless explicitly overridden

Example workflow:

```lua
-- Start with concealment disabled globally
require("essence").setup({ conceal = false })

-- Enable for just the current buffer
:EssenceConcealEnable

-- Or enable globally for all future buffers
:EssenceConcealEnableGlobal
```

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
