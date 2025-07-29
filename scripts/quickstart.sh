#!/bin/sh
# /qompassai/wasm/scripts/quickstart.sh
# Qompass AI WASM Quick Start
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
set -eu
IFS=' 
'
XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
WASM_CONFIG_DIR="$XDG_CONFIG_HOME/wasm"
WASM_DATA_DIR="$XDG_DATA_HOME/wasm"
mkdir -p "$XDG_BIN_HOME" "$WASM_CONFIG_DIR" "$WASM_DATA_DIR"
case ":$PATH:" in
*":$XDG_BIN_HOME:"*) ;;
*) PATH="$XDG_BIN_HOME:$PATH" ;;
esac
export PATH
NEEDED_TOOLS="curl tar wget git"
MISSING=""
for tool in $NEEDED_TOOLS; do
        if ! command -v "$tool" >/dev/null 2>&1; then
                if [ -x "/usr/bin/$tool" ]; then
                        ln -sf "/usr/bin/$tool" "$XDG_BIN_HOME/$tool"
                        printf " → Added symlink for %s in %s\n" "$tool" "$XDG_BIN_HOME"
                else
                        MISSING="$MISSING $tool"
                fi
        fi
done
if [ -n "$MISSING" ]; then
        printf "⚠ Missing tools: %s\n" "$MISSING"
        printf "Please install with your package manager.\n"
        exit 1
fi
printf '╭──────────────────────────────────────╮\n'
printf '│     Qompass AI · WASM Quick‑Start    │\n'
printf '╰──────────────────────────────────────╯\n'
printf '   © 2025 Qompass AI. All rights reserved\n\n'
printf "This script will set up a local WebAssembly (WASM) developer toolkit in:\n"
printf "  %s (binaries)\n  %s (config)\n  %s (data)\n\n" "$XDG_BIN_HOME" "$WASM_CONFIG_DIR" "$WASM_DATA_DIR"
printf "Choose WASM runtimes to install:\n"
printf " 1) Wasmtime (Bytecode Alliance)\n"
printf " 2) Wasmer (JIT/WASI)\n"
printf " 3) Wazero (Go, portable)\n"
printf " 4) All (recommended)\n"
printf " q) Quit\n"
printf "Selection [4]: "
read -r CHOICE
[ -z "$CHOICE" ] && CHOICE=4
[ "$CHOICE" = "q" ] && exit 0
RUNTIMES=""
case "$CHOICE" in
1) RUNTIMES="wasmtime" ;;
2) RUNTIMES="wasmer" ;;
3) RUNTIMES="wazero" ;;
4) RUNTIMES="wasmtime wasmer wazero" ;;
*)
        printf "Unknown selection.\n"
        exit 1
        ;;
esac
arch_detect() {
        UNAME_ARCH="$(uname -m)"
        case "$UNAME_ARCH" in
        x86_64) echo "x86_64" ;;
        aarch64 | arm64) echo "aarch64" ;;
        *) echo "$UNAME_ARCH" ;;
        esac
}
ARCH=$(arch_detect)
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
install_wasmtime() {
        printf "→ Installing Wasmtime ...\n"
        LATEST="$(curl -s https://api.github.com/repos/bytecodealliance/wasmtime/releases/latest | grep -o 'tag_name": *"[^"]*' | head -1 | awk -F'"' '{print $3}')"
        [ -z "$LATEST" ] && LATEST="v21.0.0"
        URL="https://github.com/bytecodealliance/wasmtime/releases/download/$LATEST/wasmtime-$LATEST-${ARCH}-${OS}.tar.xz"
        DEST="$WASM_DATA_DIR/wasmtime"
        mkdir -p "$DEST"
        curl -fsSL "$URL" | tar -xJ -C "$DEST" --strip-components=1
        ln -sf "$DEST/wasmtime" "$XDG_BIN_HOME/wasmtime"
        printf " · Wasmtime installed and linked.\n"
}
install_wasmer() {
        printf "→ Installing Wasmer ...\n"
        WASMER_URL="https://get.wasmer.io"
        curl -fsSL "$WASMER_URL" | sh -s -- -y --prefix "$WASM_DATA_DIR/wasmer"
        ln -sf "$WASM_DATA_DIR/wasmer/bin/wasmer" "$XDG_BIN_HOME/wasmer"
        printf " · Wasmer installed and linked.\n"
}
install_wazero() {
        printf "→ Installing Wazero ...\n"
        LATEST="$(curl -s https://api.github.com/repos/tetratelabs/wazero/releases/latest | grep -o 'tag_name\": *\"[^\"]*' | head -1 | awk -F'\"' '{print $3}')"
        [ -z "$LATEST" ] && LATEST="v1.7.0"
        FILE="wazero-${OS}-${ARCH}"
        URL="https://github.com/tetratelabs/wazero/releases/download/$LATEST/$FILE"
        curl -fsSL "$URL" -o "$XDG_BIN_HOME/wazero"
        chmod +x "$XDG_BIN_HOME/wazero"
        printf " · Wazero installed.\n"
}
for R in $RUNTIMES; do
        case "$R" in
        wasmtime) install_wasmtime ;;
        wasmer) install_wasmer ;;
        wazero) install_wazero ;;
        esac
done
add_path_to_shell_rc() {
        rcfile=$1
        line="export PATH=\"$XDG_BIN_HOME:\$PATH\""
        if [ -f "$rcfile" ]; then
                if ! grep -Fxq "$line" "$rcfile"; then
                        printf '\n# Added by Qompass AI WASM quickstart script\n%s\n' "$line" >>"$rcfile"
                        printf " → Added PATH export to %s\n" "$rcfile"
                fi
        fi
}
add_path_to_shell_rc "$HOME/.bashrc"
add_path_to_shell_rc "$HOME/.zshrc"
add_path_to_shell_rc "$HOME/.profile"
printf "\n✅ WASM developer environment set up in user space!\n"
printf "→ Binaries: %s (add to your PATH if not there already)\n" "$XDG_BIN_HOME"
printf "→ Data:     %s\n" "$WASM_DATA_DIR"
printf "→ Config:   %s\n" "$WASM_CONFIG_DIR"
printf "\nTest with: wasmtime --version, wasmer --version, wazero --help\n"
printf "Please restart your terminal or run 'export PATH=\"%s:\$PATH\"' to update your environment.\n" "$XDG_BIN_HOME"
exit 0
