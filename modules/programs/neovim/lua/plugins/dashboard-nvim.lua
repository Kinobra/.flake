local home = os.getenv('HOME')
local db = require('dashboard')
local g = vim.g

db.custom_header = {[[]],
    [[=================     ===============     ===============   ========  ========]],
    [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
    [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
    [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
    [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
    [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
    [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
    [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
    [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
    [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
    [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
    [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
    [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
    [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
    [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
    [[||.=='    _-'                                                     `' |  /==.||]],
    [[=='    _-'                        N E O V I M                         \/   `==]],
    [[\   _-'                                                                `-_   /]],
    [[ `''                                                                      ``' ]],
    [[]]}

g.dashboard_default_executive ='fzf'
vim.cmd([[
    nnoremap    <silent>    <Leader>fn      :new<CR>
    nnoremap    <silent>    <Leader>ff      :Files<CR>
    nnoremap    <silent>    <Leader>fB      :Lfcd<CR>
    nnoremap    <silent>    <Leader>fb      :Lf<CR>
    "nmap                    <Leader>ss      :<C-u>SessionSave<CR>
    "nmap                    <Leader>sl      :<C-u>SessionLoad<CR>
    "nnoremap    <silent>    <Leader>fh      :DashboardFindHistory<CR>
    "nnoremap    <silent>    <Leader>fa      :DashboardFindWord<CR>
]])

db.custom_center = {
    {
        icon = 'O  ',
        desc = 'Create new file                         ',
        action ='new',
        shortcut = 'SPC f n'
    },
    {
        icon = 'O  ',
        desc = 'Recently opened files                   ',
        action =  'DashboardFindHistory',
        shortcut = 'SPC f h'
    },
    {
        icon = 'O  ',
        desc = 'Find File                               ',
        action = 'Files',
        shortcut = 'SPC f f'
    },
    {
        icon = 'O  ',
        desc ='File Browser                            ',
        action = '', -- fzf file_browser
        shortcut = 'SPC f b'
    },
    {
        icon = 'O  ',
        desc = 'Find word                               ',
        action = '', -- fzf live_grep
        shortcut = 'SPC f w'
    },
    {
        icon = 'O  ',
        desc = 'Open Personal dotfiles                  ',
        action = 'o ~/.flake/flake.nix',
        shortcut = 'SPC o c'
    }
}

db.custom_footer = {[[]],[[]],[[]],[[]],[[]],
    [[A Wise Man Once Said Nothing]],
    [[]],[[]],[[]],[[]],[[]],[[]]
}
