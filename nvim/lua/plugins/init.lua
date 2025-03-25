-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local custom_plugins = {
	"nvzone/volt",

	"nvzone/menu",

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("plugins.toggleterm")
		end,
	},

	{
		"nvzone/minty",
		cmd = { "Huefy", "Shades" },
	},

	{
		"nvzone/typr",
		cmd = { "Typr", "TyprStats" },
		dependencies = "nvzone/volt",
		opts = {},
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugins.nvim-tree")
		end,
	},

	{ "wakatime/vim-wakatime", lazy = false },

	-- colorschemes

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("plugins.kanagawa")
		end,
	},

	{
		"Mofiqul/vscode.nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("plugins.vscode")
		end,
	},

	--

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		disabled_filetypes = { "alpha" },
		config = function()
			require("plugins.lualine")
		end,
	},

	{
		"folke/which-key.nvim",
		lazy = true,
	},

	{
		"akinsho/bufferline.nvim",
		lazy = false,
		dependencies = {
			"moll/vim-bbye",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugins.bufferline")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		config = function()
			require("plugins.treesitter") -- Loads the Treesitter configuration
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("plugins.telescope") -- Loads the Telescope configuration
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			require("plugins.cmp")
		end,
	},

	require("plugins.lsp"),

	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"jayp0521/mason-null-ls.nvim", -- ensures dependencies are installed
		},
		config = function()
			require("plugins.none-ls")
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signs_staged = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		config = function()
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set(
				"v",
				"<C-_>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
			vim.keymap.set(
				"v",
				"<C-c>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
			vim.keymap.set(
				"v",
				"<C-/>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			require("alpha").setup(require("plugins.alpha"))
		end,
	},

	require("plugins.misic"),

	{
		"mfussenegger/nvim-dap",
	},
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
			crates.show()
		end,
	},
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = false,
		config = function(_, opts)
			require("nvim-dap-virtual-text").setup(opts)
		end,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function(_, opts)
			require("gopher").setup(opts)
		end,
		build = function()
			vim.cmd([[silent! GoInstallDeps]])
		end,
	},
}

require("lazy").setup(custom_plugins)
