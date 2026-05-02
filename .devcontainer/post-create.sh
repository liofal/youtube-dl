#!/usr/bin/env bash
set -euo pipefail

SOPS_VERSION="v3.12.1"

export PATH="/usr/local/share/npm-global/bin:/usr/local/bin:${PATH}"

ensure_sops() {
  local arch
  local sops_arch
  local tmp_file

  if command -v sops >/dev/null 2>&1; then
    return
  fi

  arch="$(uname -m)"
  case "${arch}" in
    x86_64) sops_arch="amd64" ;;
    aarch64|arm64) sops_arch="arm64" ;;
    *)
      echo "Unsupported architecture for sops install: ${arch}" >&2
      exit 1
      ;;
  esac

  tmp_file="$(mktemp)"
  trap 'rm -f "${tmp_file}"' RETURN

  curl -fsSL \
    -o "${tmp_file}" \
    "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.${sops_arch}"

  chmod +x "${tmp_file}"
  sudo install -m 0755 "${tmp_file}" /usr/local/bin/sops
}

ensure_pi_coding_agent() {
  local pi_bin
  local npm_prefix

  if ! command -v npm >/dev/null 2>&1; then
    echo "npm is required to install the Pi coding agent but was not found." >&2
    exit 1
  fi

  mkdir -p \
    "${HOME}/.pi/agent" \
    .pi/sessions

  echo "Installing Pi coding agent..."
  npm install -g @mariozechner/pi-coding-agent@latest

  pi_bin="$(command -v pi || true)"
  if [ -z "${pi_bin}" ]; then
    npm_prefix="$(npm prefix -g)"
    pi_bin="${npm_prefix}/bin/pi"
  fi

  if [ ! -x "${pi_bin}" ]; then
    echo "Pi coding agent installed, but no executable was found at ${pi_bin}." >&2
    exit 1
  fi

  if [ -d /usr/local/bin/pi ]; then
    echo "Leaving existing /usr/local/bin/pi directory in place; npm global bin is first in PATH."
  elif [ "${pi_bin}" = /usr/local/bin/pi ]; then
    return
  else
    sudo ln -sf "${pi_bin}" /usr/local/bin/pi
  fi
}

ensure_pre_commit_hooks() {
  pre-commit install --hook-type commit-msg
}

print_versions() {
  local pi_version

  pi_version="$(npm list -g --depth=0 @mariozechner/pi-coding-agent 2>/dev/null | awk -F@ '/@mariozechner\/pi-coding-agent@/ {print $NF; exit}')"

  if [ -n "${pi_version}" ]; then
    echo "Pi coding agent: ${pi_version}"
  else
    echo "Pi: $(command -v pi)"
  fi

  echo "sops: $(sops --version)"
}

ensure_sops
ensure_pi_coding_agent
ensure_pre_commit_hooks
print_versions
