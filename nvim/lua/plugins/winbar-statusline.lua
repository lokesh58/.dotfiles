return {
    {
        "rebelot/heirline.nvim",
        config = function()
            local conditions = require("heirline.conditions")
            local utils = require("heirline.utils")

            -- setup colors
            local function setup_colors()
                return {
                    bright_bg = utils.get_highlight("Folded").bg,
                    bright_fg = utils.get_highlight("Folded").fg,
                    red = utils.get_highlight("DiagnosticError").fg,
                    dark_red = utils.get_highlight("DiffDelete").bg,
                    green = utils.get_highlight("String").fg,
                    blue = utils.get_highlight("Function").fg,
                    gray = utils.get_highlight("NonText").fg,
                    orange = utils.get_highlight("Constant").fg,
                    purple = utils.get_highlight("Statement").fg,
                    cyan = utils.get_highlight("Special").fg,
                    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
                    diag_error = utils.get_highlight("DiagnosticError").fg,
                    diag_hint = utils.get_highlight("DiagnosticHint").fg,
                    diag_info = utils.get_highlight("DiagnosticInfo").fg,
                    git_del = utils.get_highlight("GitSignsChange").fg,
                    git_add = utils.get_highlight("GitSignsAdd").fg,
                    git_change = utils.get_highlight("GitSignsDelete").fg,
                }
            end
            vim.api.nvim_create_augroup("Heirline", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    utils.on_colorscheme(setup_colors)
                end,
                group = "Heirline",
            })

            -- create statusline components

            -- Utils
            local Align = { provider = "%=" }
            local Space = { provider = " " }

            -- ViMode
            local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, false, true)
            local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, false, true)

            local MacroRec = {
                condition = function()
                    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
                end,
                provider = " ",
                hl = { fg = "orange", bold = true },
                utils.surround({ "[", "]" }, nil, {
                    provider = function()
                        return vim.fn.reg_recording()
                    end,
                    hl = { fg = "green", bold = true },
                }),
                update = {
                    "RecordingEnter",
                    "RecordingLeave",
                },
            }

            local ShowCmd = {
                condition = function()
                    return vim.o.showcmdloc == "statusline"
                end,
                provider = ":%3.5(%S%)",
            }

            local ViMode = {
                init = function(self)
                    self.mode = vim.fn.mode() -- :h mode()
                end,
                static = {
                    mode_info = {
                        ["n"] = { long = "Normal", short = "N", color = "blue" },
                        ["v"] = { long = "Visual", short = "V", color = "cyan" },
                        ["V"] = { long = "V-Line", short = "V-L", color = "cyan" },
                        [CTRL_V] = { long = "V-Block", short = "V-B", color = "cyan" },
                        ["s"] = { long = "Select", short = "S", color = "purple" },
                        ["S"] = { long = "S-Line", short = "S-L", color = "purple" },
                        [CTRL_S] = { long = "S-Block", short = "S-B", color = "purple" },
                        ["i"] = { long = "Insert", short = "I", color = "green" },
                        ["R"] = { long = "Replace", short = "R", color = "orange" },
                        ["c"] = { long = "Command", short = "C", color = "orange" },
                        ["r"] = { long = "Prompt", short = "P", color = "orange" },
                        ["!"] = { long = "Shell", short = "Sh", color = "red" },
                        ["t"] = { long = "Terminal", short = "T", color = "red" },
                    },
                },
                hl = function(self)
                    return { fg = self.mode_info[self.mode].color, bold = true }
                end,
                update = {
                    "ModeChanged",
                    "WinResized",
                },
                flexible = 1,
                {
                    provider = function(self)
                        return " %2(" .. self.mode_info[self.mode].long .. "%)"
                    end,
                },
                {
                    provider = function(self)
                        return " %2(" .. self.mode_info[self.mode].short .. "%)"
                    end,
                },
            }

            local ViModeBlock = utils.surround({ "", "" }, "bright_bg", { MacroRec, ViMode, ShowCmd })

            -- File Info
            local FileNameProvider = {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(0)
                end,
            }
            local FileIcon = {
                init = function(self)
                    local filename = self.filename
                    local extension = vim.fn.fnamemodify(filename, ":e")
                    self.icon, self.icon_color =
                        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
                end,
                provider = function(self)
                    return self.icon and (self.icon .. " ")
                end,
                hl = function(self)
                    return { fg = self.icon_color }
                end,
            }
            local FileName = {
                init = function(self)
                    self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
                    if self.lfilename == "" then
                        self.lfilename = "[No Name]"
                    end
                end,
                hl = { fg = utils.get_highlight("Directory").fg },
                flexible = 2,
                {
                    provider = function(self)
                        return self.lfilename
                    end,
                },
                {
                    provider = function(self)
                        return vim.fn.pathshorten(self.lfilename)
                    end,
                },
                {
                    provider = function(self)
                        return vim.fn.fnamemodify(self.filename, ":t")
                    end,
                },
            }
            local FileFlags = {
                {
                    condition = function()
                        return vim.bo.modified
                    end,
                    provider = "[+]",
                    hl = { fg = "green" },
                },
                {
                    condition = function()
                        return not vim.bo.modifiable or vim.bo.readonly
                    end,
                    provider = "",
                    hl = { fg = "orange" },
                },
            }
            local FileNameModifier = {
                hl = function()
                    if vim.bo.modified then
                        -- use `force` because we need to override the child's hl foreground
                        return { fg = "cyan", bold = true, force = true }
                    end
                end,
            }
            local FileNameBlock = utils.insert(
                FileNameProvider,
                FileIcon,
                utils.insert(FileNameModifier, FileName), -- a new table where FileName is a child of FileNameModifier
                FileFlags,
                { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
            )

            local FileType = {
                provider = function()
                    return vim.bo.filetype
                end,
            }
            local FileTypeBlock = {
                utils.insert(FileNameProvider, FileIcon),
                FileType,
            }

            local FileEncoding = {
                provider = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc, -- :h 'enc',
            }

            local FileFormat = {
                provider = vim.bo.fileformat,
            }

            local FileSize = {
                provider = function()
                    -- stackoverflow, compute human readable file size
                    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
                    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
                    fsize = (fsize < 0 and 0) or fsize
                    if fsize < 1024 then
                        return fsize .. suffix[1]
                    end
                    local i = math.floor((math.log(fsize) / math.log(1024)))
                    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
                end,
            }

            local FileInfoBlock = {
                hl = { fg = utils.get_highlight("Type").fg, bold = true },
                flexible = 1,
                {
                    FileTypeBlock,
                    Space,
                    FileEncoding,
                    { provider = "[" },
                    FileFormat,
                    { provider = "]" },
                    Space,
                    FileSize,
                },
                {
                    FileTypeBlock,
                    Space,
                    FileEncoding,
                    { provider = "[" },
                    FileFormat,
                    { provider = "]" },
                },
                {
                    FileTypeBlock,
                },
            }

            -- Cursor Position: Ruler
            -- We're getting minimalist here!
            local Ruler = {
                -- %l = current line number
                -- %L = number of lines in the buffer
                -- %c = column number
                -- %P = percentage through file of displayed window
                provider = "%7(%l/%3L%):%2c %P",
                hl = { bold = true },
            }

            -- Cursor Position: ScrollBar
            -- I take no credits for this! 🦁
            local ScrollBar = {
                static = {
                    sbar = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " },
                },
                provider = function(self)
                    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                    local lines = vim.api.nvim_buf_line_count(0)
                    local i = math.ceil(curr_line * #self.sbar / lines)
                    return string.rep(self.sbar[i], 2)
                end,
                hl = { fg = "bright_bg", bg = "blue" },
            }

            -- LSP
            local LSPActive = {
                condition = conditions.lsp_attached,
                init = function(self)
                    self.attached_lsps = vim.lsp.get_clients({ bufnr = 0 })
                end,
                update = { "LspAttach", "LspDetach", "WinResized" },
                on_click = {
                    callback = function()
                        vim.defer_fn(function()
                            vim.cmd("LspInfo")
                        end, 100)
                    end,
                    name = "heirline_LSP",
                },
                hl = { fg = "green", bold = true },
                flexible = 1,
                {
                    provider = function(self)
                        local names = {}
                        for _, server in ipairs(self.attached_lsps) do
                            table.insert(names, server.name)
                        end
                        return "  " .. table.concat(names, " ")
                    end,
                },
                {
                    provider = function(self)
                        return " " .. string.rep("+", #self.attached_lsps)
                    end,
                },
            }

            -- Nvim Navic
            local FullNavic = {
                condition = function()
                    return require("nvim-navic").is_available()
                end,
                static = {
                    -- create a type highlight map
                    type_hl = {
                        File = "Directory",
                        Module = "@include",
                        Namespace = "@namespace",
                        Package = "@include",
                        Class = "@structure",
                        Method = "@method",
                        Property = "@property",
                        Field = "@field",
                        Constructor = "@constructor",
                        Enum = "@field",
                        Interface = "@type",
                        Function = "@function",
                        Variable = "@variable",
                        Constant = "@constant",
                        String = "@string",
                        Number = "@number",
                        Boolean = "@boolean",
                        Array = "@field",
                        Object = "@type",
                        Key = "@keyword",
                        Null = "@comment",
                        EnumMember = "@field",
                        Struct = "@structure",
                        Event = "@keyword",
                        Operator = "@operator",
                        TypeParameter = "@type",
                    },
                    -- bit operation dark magic, see below...
                    enc = function(line, col, winnr)
                        return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
                    end,
                    -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
                    dec = function(c)
                        local line = bit.rshift(c, 16)
                        local col = bit.band(bit.rshift(c, 6), 1023)
                        local winnr = bit.band(c, 63)
                        return line, col, winnr
                    end,
                },
                init = function(self)
                    local data = require("nvim-navic").get_data() or {}
                    local children = {}
                    -- create a child for each level
                    for i, d in ipairs(data) do
                        -- encode line and column numbers into a single integer
                        local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
                        local child = {
                            {
                                provider = d.icon,
                                hl = self.type_hl[d.type],
                            },
                            {
                                -- escape `%`s (elixir) and buggy default separators
                                provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                                -- highlight icon only or location name as well
                                -- hl = self.type_hl[d.type],

                                on_click = {
                                    -- pass the encoded position through minwid
                                    minwid = pos,
                                    callback = function(_, minwid)
                                        -- decode
                                        local line, col, winnr = self.dec(minwid)
                                        vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                                    end,
                                    name = "heirline_navic",
                                },
                            },
                        }
                        -- add a separator only if needed
                        if #data > 1 and i < #data then
                            table.insert(child, {
                                provider = " > ",
                                hl = { fg = "bright_fg" },
                            })
                        end
                        table.insert(children, child)
                    end
                    -- instantiate the new child, overwriting the previous one
                    self.child = self:new(children, 1)
                end,
                -- evaluate the children containing navic components
                provider = function(self)
                    return self.child:eval()
                end,
                hl = { fg = "gray" },
                update = "CursorMoved",
            }
            local Navic = { flexible = 1, FullNavic, { provider = "" } }

            -- Diagnostics
            local Diagnostics = {
                condition = conditions.has_diagnostics,
                -- Fetching custom diagnostic icons
                static = {
                    error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
                    warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
                    info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
                    hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],
                },
                init = function(self)
                    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
                end,
                update = { "DiagnosticChanged", "BufEnter" },
                on_click = {
                    callback = function()
                        require("trouble").toggle("diagnostics")
                    end,
                    name = "heirline_diagnostics",
                },
                {
                    provider = function(self)
                        return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                    end,
                    hl = { fg = "diag_error" },
                },
                {
                    provider = function(self)
                        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                    end,
                    hl = { fg = "diag_warn" },
                },
                {
                    provider = function(self)
                        return self.info > 0 and (self.info_icon .. self.info .. " ")
                    end,
                    hl = { fg = "diag_info" },
                },
                {
                    provider = function(self)
                        return self.hints > 0 and (self.hint_icon .. self.hints)
                    end,
                    hl = { fg = "diag_hint" },
                },
            }

            -- Git
            local Git = {
                condition = conditions.is_git_repo,
                init = function(self)
                    self.status_dict = vim.b.gitsigns_status_dict
                    self.has_changes = self.status_dict.added ~= 0
                        or self.status_dict.removed ~= 0
                        or self.status_dict.changed ~= 0
                end,
                on_click = {
                    callback = function()
                        vim.defer_fn(function()
                            require("snacks").lazygit()
                        end, 100)
                    end,
                    name = "heirline_git",
                },
                hl = { fg = "orange" },
                { -- git branch name
                    provider = function(self)
                        return " " .. self.status_dict.head
                    end,
                    hl = { bold = true },
                },
                -- You could handle delimiters, icons and counts similar to Diagnostics
                {
                    condition = function(self)
                        return self.has_changes
                    end,
                    provider = "(",
                },
                {
                    provider = function(self)
                        local count = self.status_dict.added or 0
                        return count > 0 and ("+" .. count)
                    end,
                    hl = { fg = "git_add" },
                },
                {
                    provider = function(self)
                        local count = self.status_dict.removed or 0
                        return count > 0 and ("-" .. count)
                    end,
                    hl = { fg = "git_del" },
                },
                {
                    provider = function(self)
                        local count = self.status_dict.changed or 0
                        return count > 0 and ("~" .. count)
                    end,
                    hl = { fg = "git_change" },
                },
                {
                    condition = function(self)
                        return self.has_changes
                    end,
                    provider = ")",
                },
            }

            -- Terminal Name
            local TerminalName = {
                -- we could add a condition to check that buftype == 'terminal'
                -- or we could do that later (see #conditional-statuslines below)
                provider = function()
                    local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
                    return " " .. tname
                end,
                hl = { fg = "blue", bold = true },
            }

            -- Help FileName
            local HelpFileName = {
                condition = function()
                    return vim.bo.filetype == "help"
                end,
                provider = function()
                    local filename = vim.api.nvim_buf_get_name(0)
                    return vim.fn.fnamemodify(filename, ":t")
                end,
                hl = { fg = "blue" },
            }

            -- No 'cmdheight'? No problem! SearchCount, MacroRec and ShowCmd
            local SearchCount = {
                condition = function()
                    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
                end,
                init = function(self)
                    local ok, search = pcall(vim.fn.searchcount)
                    if ok and search.total then
                        self.search = search
                    end
                end,
                provider = function(self)
                    local search = self.search
                    return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
                end,
            }

            -- Statuslines!!

            local DefaultStatusline = {
                ViModeBlock,
                Space,
                Git,
                Align,
                SearchCount,
                Align,
                Diagnostics,
                Space,
                LSPActive,
                Space,
                FileInfoBlock,
                Space,
                Ruler,
                Space,
                ScrollBar,
            }

            local InactiveStatusline = {
                condition = conditions.is_not_active,
                Align,
                FileInfoBlock,
            }

            local SpecialStatusline = {
                condition = function()
                    return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive" },
                    })
                end,
                FileType,
                Space,
                HelpFileName,
                Align,
            }

            local TerminalStatusline = {
                condition = function()
                    return conditions.buffer_matches({ buftype = { "terminal" } })
                end,
                hl = { bg = "dark_red" },
                { condition = conditions.is_active, ViModeBlock },
                Align,
            }

            local StatusLines = {
                hl = function()
                    if conditions.is_active() then
                        return "StatusLine"
                    else
                        return "StatusLineNC"
                    end
                end,

                -- the first statusline with no condition, or which condition returns true is used.
                -- think of it as a switch case with breaks to stop fallthrough.
                fallthrough = false,

                SpecialStatusline,
                TerminalStatusline,
                InactiveStatusline,
                DefaultStatusline,
            }

            -- Winbars !!

            local WinBars = {
                fallthrough = false,
                { -- A special winbar for terminals
                    condition = function()
                        return conditions.buffer_matches({ buftype = { "terminal" } })
                    end,
                    utils.surround({ "", "" }, "dark_red", {
                        FileType,
                        Space,
                        TerminalName,
                    }),
                },
                { -- An inactive winbar for regular files
                    condition = function()
                        return not conditions.is_active()
                    end,
                    utils.surround(
                        { "", "" },
                        "bright_bg",
                        { hl = { fg = "gray", force = true }, FileNameBlock }
                    ),
                },
                -- A winbar for regular files
                {
                    utils.surround({ "", "" }, "bright_bg", FileNameBlock),
                    Space,
                    Navic,
                },
            }

            require("heirline").setup({
                statusline = StatusLines,
                winbar = WinBars,
                opts = {
                    -- if the callback returns true, the winbar will be disabled for that window
                    -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
                    disable_winbar_cb = function(args)
                        return conditions.buffer_matches({
                            buftype = { "nofile", "prompt", "help", "quickfix" },
                            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
                        }, args.buf)
                    end,
                },
            })
            require("heirline").load_colors(setup_colors())
        end,
    },
}
