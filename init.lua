-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local transparency = false

vim.opt.backup = false
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

--  For more options, you can see `:help option-list`

vim.o.number = true
vim.o.relativenumber = false

-- no wrapping
vim.opt.wrap = false

-- Ensure the statusline is always visible
vim.opt.laststatus = 2

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- sync clipboard with the system
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = false
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

vim.o.confirm = true

vim.o.complete = ".,w"
-- KEYMAPS
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({'n', 'o'}, '-', '$', { noremap = true, desc = "End of line" })
vim.keymap.set({'n', 'o'}, '0', '^', { desc = "Start of line" })

-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = { on_jump = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { noremap = true, silent = true, desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprev<CR>', { noremap = true, silent = true, desc = 'Previous Buffer' })

vim.keymap.set("n", "<C-8>", "<C-w>5<")
vim.keymap.set("n", "<C-9>", "<C-w>5>")
vim.keymap.set("n", "<C-7>", "<C-w>=")

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.hl_op() end,
})

--set theme
-- vim.cmd("colorscheme naysayer")

if transparency then
    vim.opt.termguicolors = true

    vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi NonText guibg=NONE ctermbg=NONE")

    vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE") -- for floating windows
    vim.cmd("hi CursorLine guibg=NONE ctermbg=NONE") -- for the current line highlight
end

-- function to toggle line numbers
local toggle_number = function() 
    vim.o.number = not vim.o.number
    vim.o.relativenumber = not vim.o.relativenumber
end
vim.keymap.set('n', '<leader>tn', toggle_number)

-- When jumping to the end of the file (G), automatically center the screen (zz)
vim.keymap.set('n', 'G', 'Gzz', { noremap = true })

-- When doing half-page jumps down (<C-d>) or up (<C-u>), center the screen
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

-- When moving to the next search result (n) or previous (N), center the screen
vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })
vim.keymap.set('n', 'G', 'Gzz', { noremap = true })

-- When doing half-page jumps down (<C-d>) or up (<C-u>), center the screen
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

-- When moving to the next search result (n) or previous (N), center the screen
vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })

vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')

-- =============================================================================================
-- =============================================================================================
-- ADD CHECK MARK
local function toggle_markdown_smart()
    local line = vim.api.nvim_get_current_line()
    local is_empty = line:match("^%s*$") ~= nil
    local current_mode = vim.api.nvim_get_mode().mode

    if line:match("%[% %]") then
        line = line:gsub("%[% %]", "[x]", 1)
    elseif line:match("%[x%]") then
        line = line:gsub("%[x%]", "[ ]", 1)
    else
        local indent = line:match("^%s*")
        local content = line:gsub("^%s*", ""):gsub("^[*-] ", "", 1)
        line = indent .. "- [ ] " .. content
    end

    vim.api.nvim_set_current_line(line)

    if current_mode:find("i") or is_empty then
        vim.cmd("startinsert!")
    end
end
vim.keymap.set({"n", "i"}, "<M-x>", toggle_markdown_smart, { desc = "Toggle Checkbox" })

local function remove_markdown_completely()
    local line = vim.api.nvim_get_current_line()

    -- 1. Capture the initial indentation (%s*)
    -- 2. Match (but don't capture) the bullet [*-] and the checkbox \[.[\]]
    -- 3. Keep everything after that (%s*(.*))
    local indent, content = line:match("^(%s*)[*-]%s*%[[ xX]%s*]%s*(.*)")

    -- If it didn't match a checkbox, try matching just a standard bullet
    if not content then
        indent, content = line:match("^(%s*)[*-]%s*(.*)")
    end

    -- If a match was found, update the line; otherwise leave it alone
    if content then
        vim.api.nvim_set_current_line(indent .. content)
    end
end

-- Map it to a key (e.g., Alt+Shift+X)
vim.keymap.set({"n", "i"}, "<M-l>", remove_markdown_completely, { desc = "Remove Bullet and Checkbox" })


-- =============================================================================================
-- =============================================================================================
-- TABLE FORMAT
local gmatch = string.gmatch
local match = string.match
local rep = string.rep
local concat = table.concat

local function format_markdown_table_nvim(lines)
    local rows = {}
    local col_widths = {}
    local num_rows = 0
    local num_cols = 0

    for i = 1, #lines do
        local line = lines[i]

        if not match(line, "^%s*|[%-%s%|:]+|%s*$") then
            local row = {}
            local col_idx = 1

            for cell in gmatch(line, "|([^|]+)") do
                local clean_cell = match(cell, "^%s*(.-)%s*$") or ""
                row[col_idx] = clean_cell

                local cell_len = #clean_cell
                if cell_len > (col_widths[col_idx] or 0) then
                    col_widths[col_idx] = cell_len
                end
                col_idx = col_idx + 1
            end

            if col_idx > 1 then
                num_rows = num_rows + 1
                rows[num_rows] = row
                if col_idx - 1 > num_cols then
                    num_cols = col_idx - 1
                end
            end
        end
    end

    if num_rows == 0 then
        return lines
    end

    local sep_parts = {}
    for i = 1, num_cols do
        sep_parts[i] = rep("-", (col_widths[i] or 0) + 2)
    end
    local separator_line = "|" .. concat(sep_parts, "|") .. "|"

    local out = {}
    local out_idx = 1

    for r = 1, num_rows do
        local row = rows[r]
        local row_parts = {}

        for c = 1, num_cols do
            local cell = row[c] or ""
            local pad_len = (col_widths[c] or 0) - #cell
            row_parts[c] = " " .. cell .. rep(" ", pad_len) .. " "
        end

        out[out_idx] = "|" .. concat(row_parts, "|") .. "|"
        out_idx = out_idx + 1

        if r == 1 then
            out[out_idx] = separator_line
            out_idx = out_idx + 1
        end
    end

    return out
end

vim.api.nvim_create_user_command("FormatTable", function(opts)
    local start_line = opts.line1 - 1
    local end_line = opts.line2

    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

    local formatted_lines = format_markdown_table_nvim(lines)

    vim.api.nvim_buf_set_lines(0, start_line, end_line, false, formatted_lines)
end, { range = true, desc = "Format Markdown Table" })

vim.keymap.set("v", "<leader>tf", ":FormatTable<CR>", { desc = "Format selected table" })


local map = vim.keymap.set
local expr = { expr = true }

-- Helper: Get character after cursor
local function skip(c) 
    return vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.')) == c and "<Right>" or c 
end

-- 1. Simple Openers (Pure speed, no logic)
map("i", "(", "()<Left>")
map("i", "[", "[]<Left>")
map("i", "{", "{}<Left>")

-- 2. Closers (Step over if they exist)
map("i", ")", function() return skip(")") end, expr)
map("i", "]", function() return skip("]") end, expr)
map("i", "}", function() return skip("}") end, expr)

-- 3. Quotes (Step over OR create pair)
local function quote(c) 
    return skip(c) == "<Right>" and "<Right>" or c..c.."<Left>" 
end
map("i", '"', function() return quote('"') end, expr)
map("i", "'", function() return quote("'") end, expr)
map("i", "`", function() return quote("`") end, expr)

-- 4. The C-Style Enter Trick
map("i", "<CR>", function()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    -- If cursor is exactly between {}, crack them open
    if line:sub(col - 1, col) == "{}" then
        return "<CR><C-o>O"
    end
    return "<CR>"
end, expr)

-- 5. The Backspace Eraser
map("i", "<BS>", function()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    local pair = line:sub(col - 1, col)
    -- If sitting between any empty pair, delete both
    if pair == "()" or pair == "[]" or pair == "{}" or pair == '""' or pair == "''" or pair == "``" then
        return "<BS><Right><BS>"
    end
    return "<BS>"
end, expr)

-- surround keymaps
-- Select text, press ( to get (text)
vim.keymap.set("x", "(", 'c(<C-r>")<Esc>')
vim.keymap.set("x", "[", 'c[<C-r>"]<Esc>')
vim.keymap.set("x", "{", 'c{<C-r>"}<Esc>')
vim.keymap.set("x", "<", 'c<<C-r>"><Esc>')
vim.keymap.set("x", '"', 'c"<C-r>""<Esc>')
vim.keymap.set("x", "'", "c'<C-r>\"'<Esc>")

-- =============================================================================================
-- =============================================================================================
-- this is the alt-d behavior
-- Function to prep a global search and replace for the word under the cursor
local function change_all_occurrences()
    local word = vim.fn.expand("<cword>") -- Get the word under cursor
    -- Prep the command: %s/old_word/|/g (the | is where you type)
    local cmd = ":%s/" .. word .. "//g<Left><Left>"

    -- Feed the keys to the command line
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(cmd, true, false, true), 
        "n", 
        false
    )
end

vim.keymap.set("n", "<M-d>", change_all_occurrences, { desc = "Change all occurrences of word" })

-- =============================================================================================
-- =============================================================================================
-- -- Navigate search results without leaving your file
vim.keymap.set("n", "<M-p>", ":cprev<CR>zz", { desc = "Previous search result" })
vim.keymap.set("n", "<M-n>", ":cnext<CR>zz", { desc = "Next search result" })



-- =============================================================================================
-- =============================================================================================
--  THIS IS THE SHORTCUT TO THE CONFIG
-- Open Neovim configuration file from anywhere
vim.keymap.set("n", "<leader>ec", function()
    -- Get the path to your config directory and append '/init.lua'
    local config_path = vim.fn.stdpath("config") .. "/init.lua"
    vim.cmd("edit " .. config_path)
end, { desc = "Edit Neovim config" })



-- =============================================================================================
-- =============================================================================================
-- TODO highlight

-- Create a custom highlight group for keywords
vim.api.nvim_set_hl(0, "CustomImpo", { fg = "#000000", bg = "#FF4500", bold = true })
vim.api.nvim_set_hl(0, "CustomTodo", { fg = "#000000", bg = "#FFCC00", bold = true })
vim.api.nvim_set_hl(0, "CustomNote", { fg = "#000000", bg = "#00CCFF", bold = true })

local function highlight_keywords()
    -- Clear existing matches to prevent stacking
    for _, match in ipairs(vim.fn.getmatches()) do
        if match.group == "CustomTodo" or match.group == "CustomNote" or match.group == "CustomImpo" then
            vim.fn.matchdelete(match.id)
        end
    end

    -- Add matches for specific keywords
    vim.fn.matchadd("CustomImpo", [[\v<(FIXME|IMPORTANT)>]])
    vim.fn.matchadd("CustomTodo", [[\v<(TODO|WARNING)>]])
    vim.fn.matchadd("CustomNote", [[\v<(NOTE|HARDCODED)>]])
end

-- Run the function whenever a buffer is entered
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    callback = highlight_keywords,
})

-- function to open and edit the Global Todos
local Todos = function()
    local global_todos = "./Todos.md"
    local todos_path = vim.fn.stdpath("config") .. global_todos
    if vim.fn.filereadable(todos_path) ~= 0 then
        vim.cmd("edit " .. todos_path)
    else
        print("TODOS.md is not readable. Please check if the file exisits!")
    end
end
vim.keymap.set("n", "<leader>td", Todos, {desc = "Global todos files, kepth in the config dir"})


-- =============================================================================================
-- =============================================================================================
-- NEOVIDE CONFIG
if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono Nerd Font:h13" -- text below applies for VimScript
    vim.g.neovide_disable_all_animations = true
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_vfx_mode = ""
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_position_animation_length = 0.0
    vim.g.neovide_scroll_animation_length = 0.0
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_no_idle = true
end

-- =============================================================================================
-- =============================================================================================
-- NOTEPAD++ style changes tracker
local ns = vim.api.nvim_create_namespace("npp_tracker")

-- We need two caches to mimic Notepad++
local opened_cache = {}
local saved_cache = {}

-- Notepad++ Colors (Orange for Unsaved, Green for Saved)
vim.api.nvim_set_hl(0, "NppUnsaved", { fg = "#F39C12", bold = true }) -- Orange
vim.api.nvim_set_hl(0, "NppSaved",   { fg = "#2ECC71", bold = true }) -- Green

-- 1. Caches the state when the file is FIRST opened
local function cache_open(buf)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
    opened_cache[buf] = text
    saved_cache[buf]  = text
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

-- 2. Updates the saved state when you hit :w
local function cache_save(buf)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
    saved_cache[buf] = text
end

-- 3. Core logic: Compare the live buffer against BOTH caches
local function update_npp_signs(buf)
    if not vim.api.nvim_buf_is_valid(buf) then return end

    local t_open  = opened_cache[buf]
    local t_saved = saved_cache[buf]
    if not t_open or not t_saved then return end 

    local curr_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local t_curr = table.concat(curr_lines, "\n")

    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    -- Track the state of each line in a table: line_num -> { state, char }
    local line_states = {}

    -- PASS 1: Compare against Opened State (Finds Green / "Saved" changes)
    if t_open ~= t_curr then
        local hunks = vim.diff(t_open, t_curr, { result_type = "indices" })
        if hunks then
            for _, hunk in ipairs(hunks) do
                local _, count_orig, start_curr, count_curr = unpack(hunk)
                if count_curr == 0 then
                    line_states[math.max(1, start_curr)] = { type = "saved", char = "_" }
                else
                    for i = 0, count_curr - 1 do
                        line_states[start_curr + i] = { type = "saved", char = "▎" }
                    end
                end
            end
        end
    end

    -- PASS 2: Compare against Saved State (Finds Orange / "Unsaved" changes)
    -- This overrides Pass 1, because active typing takes priority over old saves
    if t_saved ~= t_curr then
        local hunks = vim.diff(t_saved, t_curr, { result_type = "indices" })
        if hunks then
            for _, hunk in ipairs(hunks) do
                local _, count_orig, start_curr, count_curr = unpack(hunk)
                if count_curr == 0 then
                    line_states[math.max(1, start_curr)] = { type = "unsaved", char = "_" }
                else
                    for i = 0, count_curr - 1 do
                        line_states[start_curr + i] = { type = "unsaved", char = "▎" }
                    end
                end
            end
        end
    end

    -- PASS 3: Render the signs to the gutter
    for line, state in pairs(line_states) do
        local hl = state.type == "unsaved" and "NppUnsaved" or "NppSaved"
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, line - 1, 0, {
            sign_text = state.char,
            sign_hl_group = hl,
            priority = 10,
        })
    end
end

-- Set up autocommands to handle the lifecycle
local npp_augroup = vim.api.nvim_create_augroup("NppTracker", { clear = true })

-- When you open a file, establish the baseline
vim.api.nvim_create_autocmd("BufReadPost", {
    group = npp_augroup,
    callback = function(args) cache_open(args.buf) end,
})

-- When you save, update the save cache and trigger a sign update to turn Orange into Green
vim.api.nvim_create_autocmd("BufWritePost", {
    group = npp_augroup,
    callback = function(args) 
        cache_save(args.buf) 
        update_npp_signs(args.buf)
    end,
})

-- While you type, update the signs live (Orange)
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = npp_augroup,
    callback = function(args) update_npp_signs(args.buf) end,
})

-- Cleanup memory when a buffer is closed entirely
vim.api.nvim_create_autocmd("BufWipeout", {
    group = npp_augroup,
    callback = function(args) 
        opened_cache[args.buf] = nil
        saved_cache[args.buf]  = nil 
    end,
})

-- Initialize currently open buffers (useful if you source this file while running)
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
        cache_open(buf)
    end
end


-- =============================================================================================
-- =============================================================================================
-- MICRO HARPOON
local MicroHarpoon = { marks = {} }

--- Adds current file to the list
function MicroHarpoon.add()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then return end

    -- Prevent duplicates
    for _, mark in ipairs(MicroHarpoon.marks) do
        if mark == file then 
            print("Already marked!") 
            return 
        end
    end

    MicroHarpoon.marks[#MicroHarpoon.marks + 1] = file
    print("Harpooned: " .. vim.fn.fnamemodify(file, ":t"))
end

--- Jumps to a specific index instantly
function MicroHarpoon.nav(idx)
    local file = MicroHarpoon.marks[idx]
    if file then 
        vim.cmd("edit " .. vim.fn.fnameescape(file)) 
    end
end

--- Displays a native, ultra-fast selection menu
function MicroHarpoon.menu()
    if #MicroHarpoon.marks == 0 then 
        print("Harpoon is empty") 
        return 
    end

    -- vim.ui.select hooks into Neovim's native command line or your UI plugin
    vim.ui.select(MicroHarpoon.marks, {
        prompt = " Harpoon ",
        format_item = function(item)
            return vim.fn.fnamemodify(item, ":~:.") -- Shows clean relative paths
        end,
    }, function(choice, idx)
        if choice then MicroHarpoon.nav(idx) end
    end)
end

-- Keymaps
vim.keymap.set("n", "<leader>a", MicroHarpoon.add, { desc = "Harpoon Add" })
vim.keymap.set("n", "<leader>h", MicroHarpoon.menu, { desc = "Harpoon Menu" })

vim.keymap.set("n", "<leader>1", function() MicroHarpoon.nav(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>2", function() MicroHarpoon.nav(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>3", function() MicroHarpoon.nav(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>4", function() MicroHarpoon.nav(4) end, { desc = "Harpoon 4" })
vim.keymap.set("n", "<leader>5", function() MicroHarpoon.nav(4) end, { desc = "Harpoon 5" })
vim.keymap.set("n", "<leader>6", function() MicroHarpoon.nav(4) end, { desc = "Harpoon 6" })
vim.keymap.set("n", "<leader>7", function() MicroHarpoon.nav(4) end, { desc = "Harpoon 7" })

-- PLUGINS ================================================================================
-- ========================================================================================

vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('fff.nvim') end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = true, show_scores = true },
}


require('fff').setup({
  base_path = vim.fn.getcwd(),
  prompt = '> ',
  title = 'FFFiles',
  max_results = 100,
  max_threads = 4,
  lazy_sync = true,
  prompt_vim_mode = false,
  layout = {
    height = 0.4,
    width = 1.0,
    prompt_position = 'bottom',   -- or 'top'
    preview_position = 'top',   -- 'left' | 'right' | 'top' | 'bottom'
    preview_size = 0.5,
    flex = { size = 150, wrap = 'top' },
    show_scrollbar = true,
    path_shorten_strategy = 'middle_number', -- 'middle_number' | 'middle' | 'end'
    anchor = 'bottom',
  },
  preview = {
    enabled = false,
    max_size = 10 * 1024 * 1024,
    chunk_size = 8192,
    binary_file_threshold = 1024,
    imagemagick_info_format_str = '%m: %wx%h, %[colorspace], %q-bit',
    line_numbers = false,
    cursorlineopt = 'both',
    wrap_lines = false,
    filetypes = {
      svg = { wrap_lines = true },
      markdown = { wrap_lines = true },
      text = { wrap_lines = true },
    },
  },
  keymaps = {
    close = '<Esc>',
    select = '<CR>',
    select_split = '<C-s>',
    select_vsplit = '<C-v>',
    select_tab = '<C-t>',
    move_up = { '<Up>', '<C-p>' },
    move_down = { '<Down>', '<C-n>' },
    preview_scroll_up = '<C-u>',
    preview_scroll_down = '<C-d>',
    toggle_debug = '<F2>',
    cycle_grep_modes = '<S-Tab>',
    cycle_previous_query = '<C-Up>',
    toggle_select = '<Tab>',
    send_to_quickfix = '<C-q>',
    focus_list = '<leader>l',
    focus_preview = '<leader>p',
  },
  frecency = {
    enabled = true,
    db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
  },
  history = {
    enabled = true,
    db_path = vim.fn.stdpath('data') .. '/fff_queries',
    min_combo_count = 3,
    combo_boost_score_multiplier = 100,
  },
  git = {
    status_text_color = true, -- true to color filenames by git status
  },
  grep = {
    max_file_size = 10 * 1024 * 1024,
    max_matches_per_file = 100,
    smart_case = true,
    time_budget_ms = 150,
    modes = { 'plain', 'regex', 'fuzzy' },
    trim_whitespace = false,
  },
  debug = { enabled = false, show_scores = false },
  logging = {
    enabled = true,
    log_file = vim.fn.stdpath('log') .. '/fff.log',
    log_level = 'info',
  },
})

vim.keymap.set('n', '<leader>ff', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', '<leader>fw', function() require('fff').live_grep() end, { desc = 'FFFind files' })

vim.pack.add({"https://github.com/thimc/gruber-darker.nvim"})
require('gruber-darker').setup({
      transparent = true, -- removes the background
    })
vim.cmd.colorscheme('gruber-darker')

vim.pack.add({
    { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable'},
})
require('mini.align').setup()

vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig'},
})
vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
