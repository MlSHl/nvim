return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local utils = require("telescope.utils")

      -- repo root (git) if available, otherwise fall back to current working dir
      local function repo_root()
        local ok, out = pcall(utils.get_os_command_output, { "git", "rev-parse", "--show-toplevel" })
        if ok and out and out[1] and out[1] ~= "" then
          return out[1]
        end
        return vim.loop.cwd()
      end

      -- directory of the current file (nice for "scope to package")
      local function file_dir()
        local p = vim.fn.expand("%:p:h")
        if p == nil or p == "" then
          return vim.loop.cwd()
        end
        return p
      end

      telescope.setup({
        defaults = {
          -- helps a LOT with mod.rs / index.ts / etc.
          path_display = { "absolute" }, -- try { "smart" } if you want relative paths always
          -- cut obvious junk in monorepos
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "target/",
            "dist/",
            "build/",
            "%.cache/",
          },
        },
      })

      pcall(telescope.load_extension, "fzf")

      -- GLOBAL (repo root) navigation: works even if you :cd / :lcd somewhere else
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({ cwd = repo_root(), hidden = true })
      end, { desc = "Find files (repo root)" })

      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({ cwd = repo_root() })
      end, { desc = "Grep text (repo root)" })

      -- FAST when repo is git-tracked
      vim.keymap.set("n", "<leader>fF", function()
        builtin.git_files({ cwd = repo_root() })
      end, { desc = "Git files (repo root)" })

      -- SCOPED navigation: “just this package / folder”
	vim.keymap.set("n", "<leader>fs", function()
	  require("telescope.builtin").find_files({ cwd = vim.fn.getcwd(), hidden = true })
	end, { desc = "Find files (cwd)" })

	vim.keymap.set("n", "<leader>fS", function()
	  require("telescope.builtin").live_grep({ cwd = vim.fn.getcwd() })
	end, { desc = "Grep (cwd)" })

      -- the rest unchanged
      vim.keymap.set("n", "<leader>fb", builtin.buffers,   { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end,
  },
}

