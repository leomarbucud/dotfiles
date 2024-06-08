lvim.builtin.alpha.mode = "dashboard"

lvim.builtin.alpha.dashboard.section.header.val = {
 [[                                                      ]],
 [[                                                      ]],
 [[██▓    ▓█████  ▒█████   ███▄ ▄███▓ ▄▄▄       ██▀███   ]],
 [[▓██▒    ▓█   ▀ ▒██▒  ██▒▓██▒▀█▀ ██▒▒████▄    ▓██ ▒ ██▒]],
 [[▒██░    ▒███   ▒██░  ██▒▓██    ▓██░▒██  ▀█▄  ▓██ ░▄█ ▒]],
 [[▒██░    ▒▓█  ▄ ▒██   ██░▒██    ▒██ ░██▄▄▄▄██ ▒██▀▀█▄  ]],
 [[░██████▒░▒████▒░ ████▓▒░▒██▒   ░██▒ ▓█   ▓██▒░██▓ ▒██▒]],
 [[░ ▒░▓  ░░░ ▒░ ░░ ▒░▒░▒░ ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░]],
 [[░ ░ ▒  ░ ░ ░  ░  ░ ▒ ▒░ ░  ░      ░  ▒   ▒▒ ░  ░▒ ░ ▒░]],
 [[  ░ ░      ░   ░ ░ ░ ▒  ░      ░     ░   ▒     ░░   ░ ]],
 [[    ░  ░   ░  ░    ░ ░         ░         ░  ░   ░     ]],
 [[                                                      ]],
 [[                                                      ]]
}

lvim.builtin.alpha.dashboard.section.buttons.entries[4] = {
    "r",
    lvim.icons.ui.History .. "  Restore Files",
    ":lua require'persistence'.load()<CR>"
}

lvim.builtin.alpha.dashboard.section.footer.val = "Leomar San Buenaventura Bucud"
