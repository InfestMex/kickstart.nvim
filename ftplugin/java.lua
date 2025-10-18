-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
  name = 'jdtls',

  -- `cmd` defines the executable to launch eclipse.jdt.ls.
  -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
  --
  -- As alternative you could also avoid the `jdtls` wrapper and launch
  -- eclipse.jdt.ls via the `java` executable
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'jdtls',
    '-configuration',
    '/home/viaguila/.cache/jdtls/config',
    '-data',
    '/home/viaguila/.cache/jdtls/workspace',
  },

  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = '/home/viaguila/dev/current/git/xstore',
  -- root_dir = vim.fs.root(0, { 'gradlew', '.git', 'git', 'mvnw' }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      format = {
        enabled = true,
        -- Formatting works by default, but you can refer to a specific file/URL if you choose
        -- settings = {
        --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
        --   profile = "GoogleStyle",
        -- },
        settings = {
          url = '~/.config/nvim/custom/files/xstore_formatter.xml',
          profile = 'xstore',
        },
      },
    },
  },

  -- This sets the `initializationOptions` sent to the language server
  -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
  -- you'll need to set the `bundles`
  --
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },
}

-- require('lspconfig').jdtls.setup(config)

require('jdtls').start_or_attach(config)
