local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        config.default_prog = { "pwsh.exe" }
        config.launch_menu = {}

        table.insert(config.launch_menu, {
            label = "PowerShell",
            args = { "pwsh.exe" },
        })

        table.insert(config.launch_menu, {
            label = "Windows PowerShell",
            args = { "powershell.exe" },
        })

        -- Detect Visual Studio installations
        local vswhere = "C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe"
        local success, stdout, stderr = wezterm.run_child_process({
            vswhere,
            "-products",
            "*",
            "-requires",
            "Microsoft.VisualStudio.Component.Roslyn.Compiler",
            "-format",
            "json",
        })

        if success then
            local installations = wezterm.json_parse(stdout)
            for _, installation in ipairs(installations) do
                local installationPath = installation.installationPath
                local displayName = installation.displayName
                local devShellDll = installationPath .. "\\Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll"
                local instanceId = installation.instanceId

                -- Add Developer PowerShell
                table.insert(config.launch_menu, {
                    label = "Developer PowerShell (" .. displayName .. ")",
                    args = {
                        "pwsh.exe",
                        "-NoExit",
                        "-Command",
                        string.format(
                            "& {Import-Module '%s'; Enter-VsDevShell '%s' -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'}",
                            devShellDll,
                            instanceId
                        ),
                    },
                })
            end
        end
    end
end

return M
