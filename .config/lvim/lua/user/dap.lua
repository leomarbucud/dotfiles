local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

local home = os.getenv('HOME')

dap.adapters.php = {
    type = 'executable',
    command = 'node',
    -- Install this to home directory https://github.com/xdebug/vscode-php-debug
    args = { home .. '/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
            ['/var/www/html/'] = "${workspaceFolder}"
        }
    }
}
