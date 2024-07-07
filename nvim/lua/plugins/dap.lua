return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb", -- adjust as needed
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.java = {
        {
          javaExec = "java",
          request = "launch",
          type = "java",
        },
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      dap.adapters.cpp = {
        type = "executable",
        attach = {
          pidProperty = "pid",
          pidSelect = "ask",
        },
        command = "lldb-vscode-11", -- my binary was called 'lldb-vscode-11'
        env = {
          LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
        },
        name = "lldb",
      }

      dap.configurations.cpp = {
        {
          name = "lldb",
          type = "cpp",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          externalTerminal = false,
          stopOnEntry = false,
          args = {},
        },
      }
    end,
  },
}
