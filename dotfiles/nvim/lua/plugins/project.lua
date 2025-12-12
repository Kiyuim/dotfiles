-- lua/plugins/project.lua
return {
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
        require("project_nvim").setup({
            detection_methods = { "pattern" },
            
            -- 【核心修改】在这里把所有语言的“身份证”都加上
            patterns = { 
                -- 1. 通用 / 版本控制 (最重要，兜底用)
                ".git", 
                "_darcs", 
                ".hg", 
                ".bzr", 
                ".svn",

                -- 2. Go
                "go.mod", 
                
                -- 3. Rust
                "Cargo.toml", 
                
                -- 4. Java / Kotlin
                "pom.xml",        -- Maven
                "build.gradle",   -- Gradle
                "gradlew", 
                
                -- 5. C / C++
                "Makefile", 
                "CMakeLists.txt", 
                "compile_commands.json",
                
                -- 6. Python
                "pyproject.toml",
                "setup.py",
                "requirements.txt",
                
                -- 7. JavaScript / TypeScript / 前端
                "package.json", 
                "tsconfig.json",
            },
            
            -- 设置为 global，保证整个编辑器都跟着项目走
            scope_chdir = 'global', 
        })
    end
}
