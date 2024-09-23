#!/bin/bash

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

detect_package_manager() {
    if command -v apt-get &>/dev/null; then
        echo "debian/ubuntu"
    elif command -v dnf &>/dev/null; then
        echo "fedora"
    elif command -v pacman &>/dev/null; then
        echo "arch"
    else
        echo "unsupported"
    fi
}

# Add local bin to PATH if not already there
add_local_bin_to_path() {
    if ! grep -q "$LOCAL_BIN" "$HOME/.bashrc"; then
        echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >> "$HOME/.bashrc"
        export PATH="$LOCAL_BIN:$PATH"
        echo "Added $LOCAL_BIN to PATH in .bashrc"
    fi
}

# Install necessary build tools and dependencies
install_dependencies() {
    local distro="$1"

    case "$distro" in
        "debian/ubuntu")
            sudo apt update
            sudo apt install -y build-essential cmake ninja-build gettext libtool libtool-bin autoconf automake pkg-config unzip curl git libssl-dev libcurl4-gnutls-dev libexpat1-dev libevent-dev libncurses5-dev bison
            ;;
        "fedora")
            sudo dnf install -y @development-tools cmake libtool autoconf automake pkg-config ninja-build gettext curl git libevent-devel ncurses-devel openssl-devel
            ;;
        "arch")
            sudo pacman -Syu --noconfirm base-devel cmake ninja libtool autoconf automake pkg-config unzip curl git libevent ncurses openssl
            ;;
        *)
            echo "Unsupported distribution. Exiting."
            exit 1
            ;;
    esac
}

# Install Neovim from source
install_nvim() {
    echo "Installing Neovim from source..."
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    make install DESTDIR="$LOCAL_BIN"
    cd ..
    rm -rf neovim
    echo "Neovim installed to $LOCAL_BIN"
}

install_git() {
    echo "Installing Git from source..."
    wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.42.0.tar.gz
    tar -xvf git-2.42.0.tar.gz
    cd git-2.42.0
    make prefix="$LOCAL_BIN" all
    make prefix="$LOCAL_BIN" install
    cd ..
    rm -rf git-2.42.0*
    echo "Git installed to $LOCAL_BIN"
}

install_tmux() {
    echo "Installing Tmux from source..."
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure --prefix="$HOME/.local"
    make && make install
    cd ..
    rm -rf tmux
    echo "Tmux installed to $LOCAL_BIN"
}

# Check if wget or curl is installed (fail if neither)
check_wget_or_curl() {
    if ! command -v wget &>/dev/null && ! command -v curl &>/dev/null; then
        echo "Error: Neither wget nor curl is installed. Please install one of them first."
        exit 1
    fi
}

# Install missing tools if they are not installed
install_missing_tools() {
    if ! command -v nvim &>/dev/null; then
        install_nvim
    else
        echo "Neovim is already installed."
    fi

    if ! command -v git &>/dev/null; then
        install_git
    else
        echo "Git is already installed."
    fi

    if ! command -v tmux &>/dev/null; then
        install_tmux
    else
        echo "Tmux is already installed."
    fi
}

setup_pluginless_dots() {
    echo "Setting up pluginless dotfiles..."
    git clone https://github.com/spagnoloG/post-install-scripts.git /tmp/post-install-scripts

    # Copy tmux
    cp /tmp/post-install-scripts/pluginless_dots/tmux/tmux.conf "$HOME/.tmux.conf"

    # Copy neovim
    mkdir -p "$HOME/.config/nvim"
    cp /tmp/post-install-scripts/pluginless_dots/nvim/init.vim "$HOME/.config/nvim/init.vim"
}

main() {
    JUST_DOTS=0
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --just-dots)
                JUST_DOTS=1
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done


    # If --just-dots is passed, skip program installation
    if [[ "$JUST_DOTS" -eq 1 ]]; then
        echo "Installing dotfiles only..."
        setup_pluginless_dots
        source "$HOME/.bashrc"
        echo "Dotfiles installed."
        exit 0
    fi

    distro=$(detect_package_manager)
    if [[ "$distro" == "unsupported" ]]; then
        echo "Unsupported distribution. Exiting."
        exit 1
    fi

    # Add local bin to PATH
    add_local_bin_to_path

    install_dependencies "$distro"

    check_wget_or_curl

    install_missing_tools

    setup_pluginless_dots

    source "$HOME/.bashrc"

    echo "Script execution complete."
}

# Execute main function
main "$@"
