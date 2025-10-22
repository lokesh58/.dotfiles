# Set variables
$dotfilesRepo = "git@github.com:lokesh58/.dotfiles.git"
$dotfilesDir = "$env:USERPROFILE\.dotfiles"

# Function to install tools via Scoop
# function Install-ScoopTools {
#     Write-Output "Installing tools via Scoop..."
#     scoop install 
# }

# Clone dotfiles repository
function Clone-Dotfiles {
    if (!(Test-Path -Path $dotfilesDir)) {
        Write-Output "Dotfiles repository not found. Cloning..."
        git clone $dotfilesRepo $dotfilesDir
    } else {
        Write-Output "Dotfiles repository already exists at $dotfilesDir."
    }
}

# Create symbolic links
function Create-Link($target, $linkPath) {
    if (Test-Path $linkPath) {
        Remove-Item $linkPath -Force
    }
    New-Item -ItemType SymbolicLink -Path $linkPath -Target $target | Out-Null
}

# Create local config file if missing, from example
function Create-LocalConfig($localFilePath, $exampleFilePath, $name) {
    if (!(Test-Path $localFilePath)) {
        if (Test-Path $exampleFilePath) {
            Write-Output "$name not found. Creating from example file..."
            Copy-Item $exampleFilePath $localFilePath
        } else {
            Write-Output "Warning: Example file $exampleFilePath not found. Cannot create $name."
        }
    } else {
        Write-Output "$name already exists."
    }
}

# Setup dotfiles links and local configs
function Setup-DotfilesLinks {
    # Create necessary config directories
    $dirs = @(
        "$env:USERPROFILE\AppData\Local\nvim",
        "$env:USERPROFILE\AppData\Roaming\ssh",
        "$env:LOCALAPPDATA\clangd"
    )
    foreach ($dir in $dirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir | Out-Null
        }
    }

    # Symlink mappings (source in dotfiles repo => target on Windows)
    $links = @(
        @{Source="$dotfilesDir\git\gitconfig"; Target="$env:USERPROFILE\.gitconfig"},
        @{Source="$dotfilesDir\ssh\config"; Target="$env:USERPROFILE\.ssh\config"},
        @{Source="$dotfilesDir\wezterm"; Target="$env:USERPROFILE\.config\wezterm"},
        @{Source="$dotfilesDir\nvim"; Target="$env:LOCALAPPDATA\nvim"},
        @{Source="$dotfilesDir\clangd"; Target="$env:LOCALAPPDATA\clangd"}
    )

    foreach ($link in $links) {
        Create-Link -target $link.Source -linkPath $link.Target
    }

    # Create local config files if missing
    Create-LocalConfig -localFilePath "$dotfilesDir\git\gitconfig.local" -exampleFilePath "$dotfilesDir\git\gitconfig.local.example" -name "gitconfig.local"
    Create-LocalConfig -localFilePath "$dotfilesDir\ssh\config.local" -exampleFilePath "$dotfilesDir\ssh\config.local.example" -name "ssh config.local"
}

# Start setup
Write-Output "Starting setup..."
# Install-ScoopTools
# Clone-Dotfiles
Setup-DotfilesLinks
Write-Output "Setup complete!"
