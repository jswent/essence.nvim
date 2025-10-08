# TODO

## Features

### Icon Support

- [ ] Add support for nvim-web-devicons fallback (lua/essence/init.lua:50)
  - Currently only supports mini.icons
  - Should fallback to nvim-web-devicons if mini.icons is not available

### LSP Integration

- [ ] Automatically download conjure binary if not present (lua/essence/lsp.lua:45)
  - Currently requires manual installation of conjure
  - Could download/cache the binary automatically for better user experience
