return {
    {
        "folke/tokyonight.nvim",
        opts = {
            transparent = true, 
            styles = {
                sidebars = "transparent", 
                floats = "transparent", 
            },
        },
        dependencies = {
            "nvim-lualine/lualine.nvim",
            "nvim-tree/nvim-web-devicons",
            "utilyre/barbecue.nvim",
            "SmiteshP/nvim-navic",
        },
        config = function(_, opts)
            -- 1. 先应用配置 (透明设置)
            require("tokyonight").setup(opts)
            
            -- 2. 加载配色方案
            vim.cmd[[colorscheme tokyonight-storm]]
            
            -- 3. 配置其他相关插件
            require('lualine').setup({
                options = {
                    theme = 'tokyonight'
                },
            })
            require('barbecue').setup {
                theme = 'tokyonight',
            }
        end
    },
}