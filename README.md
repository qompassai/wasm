<!----------/qompassai/wasm/README.md ---------------->
<!-- ----------Qompass AI WASM ----------------------->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->
<!-------------------------------------------------------->

<h2> Web Assembly (aka "Wasm")</h2>

<h3> Qompass AI on wasm </h3>

![Repository Views](https://komarev.com/ghpvc/?username=qompassai-wasm)
![GitHub all releases](https://img.shields.io/github/downloads/qompassai/wasm/total?style=flat-square)

<p align="center">
<a href="https://webassembly.org/">
  <img src="https://img.shields.io/badge/WebAssembly-654FF0?style=for-the-badge&logo=webassembly&logoColor=white"
    alt="WebAssembly">
</a>
<br>
<a href="https://webassembly.org/docs/">
  <img src="https://img.shields.io/badge/Wasm_Documentation-blue?style=flat-square" alt="WebAssembly Documentation">
</a>
<a href="https://github.com/topics/webassembly-tutorial">
  <img src="https://img.shields.io/badge/Wasm_Tutorials-green?style=flat-square" alt="WebAssembly Tutorials">
</a>
<br>
<a href="./LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License: Apache 2.0"></a>

</p>

<details>
  <summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;">
    <strong>▶️ Qompass AI Quick Start</strong>
  </summary>
  <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace;">

```sh
curl -fSsL https://raw.githubusercontent.com/qompassai/wasm/main/scripts/quickstart.sh | sh
```
  </div>
  <blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
    <details>
      <summary style="font-size: 1em; font-weight: bold; padding: 10px; background: #e9ecef; color: #333; border-radius: 5px; cursor: pointer; margin: 10px 0;">
        <strong>📄 We STRONGLY advise you read the script BEFORE running it 😉</strong>
      </summary>
      <pre style="background: #fff; padding: 15px; border-radius: 5px; border: 1px solid #ddd; overflow-x: auto;">
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
</pre> </details> <p>Or, <a href="https://github.com/qompassai/wasm/blob/main/scripts/quickstart.sh" target="_blank">View the quickstart script</a>.</p>

  </blockquote>
</details>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🧭 About Qompass AI</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">
  <p>Owner<br>
  Former Intelligence Officer<br>
  Educator & Learner<br>
  DeepTech Founder & CEO</p>
</div>

<h3>Publications</h3>
  <p>
    <a href="https://orcid.org/0000-0002-0302-4812">
      <img src="https://img.shields.io/badge/ORCID-0000--0002--0302--4812-green?style=flat-square&logo=orcid" alt="ORCID">
    </a>
    <a href="https://www.researchgate.net/profile/Matt-Porter-7">
      <img src="https://img.shields.io/badge/ResearchGate-Open--Research-blue?style=flat-square&logo=researchgate" alt="ResearchGate">
    </a>
    <a href="https://zenodo.org/communities/qompassai">
      <img src="https://img.shields.io/badge/Zenodo-Publications-blue?style=flat-square&logo=zenodo" alt="Zenodo">
    </a>
  </p>

<h3>Developer Programs</h3>

[![NVIDIA Developer](https://img.shields.io/badge/NVIDIA-Developer_Program-76B900?style=for-the-badge\&logo=nvidia\&logoColor=white)](https://developer.nvidia.com/)
[![Meta Developer](https://img.shields.io/badge/Meta-Developer_Program-0668E1?style=for-the-badge\&logo=meta\&logoColor=white)](https://developers.facebook.com/)
[![HackerOne](https://img.shields.io/badge/-HackerOne-%23494649?style=for-the-badge\&logo=hackerone\&logoColor=white)](https://hackerone.com/phaedrusflow)
[![HuggingFace](https://img.shields.io/badge/HuggingFace-qompass-yellow?style=flat-square\&logo=huggingface)](https://huggingface.co/qompass)
[![Epic Games Developer](https://img.shields.io/badge/Epic_Games-Developer_Program-313131?style=for-the-badge\&logo=epic-games\&logoColor=white)](https://dev.epicgames.com/)

<h3>Professional Profiles</h3>
  <p>
    <a href="https://www.linkedin.com/in/matt-a-porter-103535224/">
      <img src="https://img.shields.io/badge/LinkedIn-Owner-blue?style=flat-square&logo=linkedin" alt="Personal LinkedIn">
    </a>
    <a href="https://www.linkedin.com/company/95058568/">
      <img src="https://img.shields.io/badge/LinkedIn-Qompass--AI-blue?style=flat-square&logo=linkedin" alt="Startup LinkedIn">
    </a>
  </p>

<h3>Social Media</h3>
  <p>
    <a href="https://twitter.com/PhaedrusFlow">
      <img src="https://img.shields.io/badge/Twitter-@PhaedrusFlow-blue?style=flat-square&logo=twitter" alt="X/Twitter">
    </a>
    <a href="https://www.instagram.com/phaedrusflow">
      <img src="https://img.shields.io/badge/Instagram-phaedrusflow-purple?style=flat-square&logo=instagram" alt="Instagram">
    </a>
    <a href="https://www.youtube.com/@qompassai">
      <img src="https://img.shields.io/badge/YouTube-QompassAI-red?style=flat-square&logo=youtube" alt="Qompass AI YouTube">
    </a>
  </p>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #ff6b6b; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🔥 How Do I Support</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #fff5f5; border-left: 6px solid #ff6b6b; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">

<table>
<tr>
<th align="center">🏛️ Qompass AI Pre-Seed Funding 2023-2025</th>
<th align="center">🏆 Amount</th>
<th align="center">📅 Date</th>
</tr>
<tr>
<td><a href="https://github.com/qompassai/r4r" title="RJOS/Zimmer Biomet Research Grant Repository">RJOS/Zimmer Biomet Research Grant</a></td>
<td align="center">$30,000</td>
<td align="center">March 2024</td>
</tr>
<tr>
<td><a href="https://github.com/qompassai/PathFinders" title="GitHub Repository">Pathfinders Intern Program</a><br>
<small><a href="https://www.linkedin.com/posts/evergreenbio_bioscience-internships-workforcedevelopment-activity-7253166461416812544-uWUM/" target="_blank">View on LinkedIn</a></small></td>
<td align="center">$2,000</td>
<td align="center">October 2024</td>
</tr>
</table>

<br>
<h4>🤝 How To Support Our Mission</h4>

[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-EA4AAA?style=for-the-badge\&logo=github-sponsors\&logoColor=white)](https://github.com/sponsors/phaedrusflow)
[![Patreon](https://img.shields.io/badge/Patreon-Support-F96854?style=for-the-badge\&logo=patreon\&logoColor=white)](https://patreon.com/qompassai)
[![Liberapay](https://img.shields.io/badge/Liberapay-Donate-F6C915?style=for-the-badge\&logo=liberapay\&logoColor=black)](https://liberapay.com/qompassai)
[![Open Collective](https://img.shields.io/badge/Open%20Collective-Support-7FADF2?style=for-the-badge\&logo=opencollective\&logoColor=white)](https://opencollective.com/qompassai)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-FFDD00?style=for-the-badge\&logo=buy-me-a-coffee\&logoColor=black)](https://www.buymeacoffee.com/phaedrusflow)
<details markdown="1">
<summary><strong>🔐 Cryptocurrency Donations</strong></summary>

**Monero (XMR):**

<div align="center">
  <img src="https://www.github.com/qompassai/svg/assets/monero-qr.svg" alt="Monero QR Code" width="180">
</div>

<div style="margin: 10px 0;">
    <code>42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH</code>
  </div>

<button onclick="navigator.clipboard.writeText('42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH')" style="padding: 6px 12px; background: #FF6600; color: white; border: none; border-radius: 4px; cursor: pointer;">
    📋 Copy Address
  </button>
<p><i>Funding helps us continue our research at the intersection of AI, healthcare, and education</i></p>

</blockquote>
</details>
</details>

<details id="FAQ">
  <summary><strong>Frequently Asked Questions</strong></summary>

### Q: How do you mitigate against bias?

**TLDR - we do math to make AI ethically useful**

### A: We delineate between mathematical bias (MB) - a fundamental parameter in neural network equations - and algorithmic/social bias (ASB). While MB is optimized during model training through backpropagation, ASB requires careful consideration of data sources, model architecture, and deployment strategies. We implement attention mechanisms for improved input processing and use legal open-source data and secure web-search APIs to help mitigate ASB.

[AAMC AI Guidelines | One way to align AI against ASB](https://www.aamc.org/about-us/mission-areas/medical-education/principles-ai-use)

### AI Math at a glance

## Forward Propagation Algorithm

$$
z = \sum_{i=1}^{n} w_ix_i + b
$$

Where:

* $y$ represents the model output
* $(x\_1, x\_2, ..., x\_n)$ are input features
* $(w\_1, w\_2, ..., w\_n)$ are feature weights
* $b$ is the bias term

### Neural Network Activation

For neural networks, the bias term is incorporated before activation:

$$
y = w_1x_1 + w_2x_2 + ... + w_nx_n + b
$$
$$
a = \sigma(z)
$$

Where:

* $z$ is the weighted sum plus bias
* $a$ is the activation output
* $\sigma$ is the activation function

### Attention Mechanism- aka what makes the Transformer (The "T" in ChatGPT) powerful

* [Attention High level overview video](https://www.youtube.com/watch?v=fjJOgb-E41w)

* [Attention Is All You Need Arxiv Paper](https://arxiv.org/abs/1706.03762)

The Attention mechanism equation is:

$$
\text{Attention}(Q, K, V) = \text{softmax}\left( \frac{QK^T}{\sqrt{d\_k}} \right) V
$$

Where:

* $Q$ represents the Query matrix
* $K$ represents the Key matrix
* $V$ represents the Value matrix
* $d\_k$ is the dimension of the key vectors
* $\text{softmax}(\cdot)$ normalizes scores to sum to 1

### Q: Do I have to buy a Linux computer to use this? I don't have time for that!

### A: No. You can run Linux and/or the tools we share alongside your existing operating system:

* Windows users can use Windows Subsystem for Linux [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
* Mac users can use [Homebrew](https://brew.sh/)
* The code-base instructions were developed with both beginners and advanced users in mind.

### Q: Do you have to get a masters in AI?

### A: Not if you don't want to. To get competent enough to get past ChatGPT dependence at least, you just need a computer and a beginning's mindset. Huggingface is a good place to start.

* [Huggingface](https://docs.google.com/presentation/d/1IkzESdOwdmwvPxIELYJi8--K3EZ98_cL6c5ZcLKSyVg/edit#slide=id.p)

### Q: What makes a "small" AI model?

### A: AI models ~=10 billion(10B) parameters and below. For comparison, OpenAI's GPT4o contains approximately 200B parameters.

</details>

## License

This project is licensed under the [Apache License, Version 2.0](./LICENSE).
