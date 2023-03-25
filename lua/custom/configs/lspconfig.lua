local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "jsonls", "tsserver", "html", "cssls", "pyright" }

local generalConfigs = {
  on_attach = on_attach,
  capabilities = capabilities,
}

local specificConfigs = {
  jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  tsserver = {
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
      typescript = {
        format = {
          enable = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        },
        surveys = {
          enabled = false,
        },
      },
      javascript = {
        format = {
          enable = false,
        },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          diagnosticMode = "openFilesOnly",
          diagnosticSeverityOverrides = {
            reportImportCycles = "error",
            reportUnusedImport = "warning",
            reportUnusedClass = "warning",
            reportUnusedFunction = "warning",
            reportUnusedVariable = "warning",
            reportDuplicateImport = "error",
            reportUnnecessaryCast = "warning",
            reportUnnecessaryComparison = "warning",
            reportUnnecessaryContains = "warning",
          },
        },
      },
    },
  },
}

for _, server_name in ipairs(servers) do
  if specificConfigs[server_name] then
    lspconfig[server_name].setup(vim.tbl_deep_extend(generalConfigs, specificConfigs[server_name]))
  else
    lspconfig[server_name].setup(generalConfigs)
  end
end
