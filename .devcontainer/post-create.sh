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
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm is required to install the Pi coding agent but was not found." >&2
    exit 1
  fi

  mkdir -p \
    "${HOME}/.pi/agent" \
    .pi/sessions

  bash .devcontainer/ensure-pi.sh
}

ensure_pre_commit_hooks() {
  pre-commit install --hook-type commit-msg
}

print_versions() {
  if command -v pi >/dev/null 2>&1; then
    echo "Pi: $(pi --version 2>&1)"
  else
    echo "Pi: $(command -v pi)"
  fi

  echo "sops: $(sops --version)"
}

ensure_sops
ensure_pi_coding_agent
ensure_pre_commit_hooks
print_versions
