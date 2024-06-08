lvim.autocommands = {
    {
        "BufWinEnter",
        {
            pattern = { "*.yml", "*.yaml" },
            command = "set shiftwidth=4",
        }
    },
    {
        "BufRead",
        {
            pattern = { "*.conf" },
            command = "set ft=config",
        }
    },
    {
        "BufWinEnter",
        {
            command = "set nofixendofline"
        }
    }
}
