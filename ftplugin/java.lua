-- See `:help vim.lsp.start` for an overview of the supported `config` options.

local current_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
local project_name
if current_dir == 'xstore' then
  project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':h:h:t')
else
  project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
end

-- TODO: if projact_name=xstore, move two folders avobe to get the correct version

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
    '/home/viaguila/.cache/jdtls/workspace/' .. project_name,
  },

  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  -- root_dir = '/home/viaguila/dev/current/git/xstore',
  -- root_dir = vim.fs.root(0, { 'gradlew', '.git', 'git', 'mvnw' }),
  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' },

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk-21.0.9.0.10-2.0.1.el9.x86_64',
          },
          {
            name = 'JavaSE-11',
            path = '/usr/lib/jvm/java-11-openjdk-11.0.25.0.9-7.0.1.el9.x86_64',
          },
        },
      },
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
      memberSortOrder = { 'SF', 'SI', 'SM', 'F', 'I', 'C', 'M', 'T' },
      symbols = {
        includeSourceMethodDeclarations = true,
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
