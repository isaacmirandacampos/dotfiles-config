#!/bin/bash
#
# Installs the latest Oneleet agent on any Linux distribution by downloading
# the published .deb, extracting it, and running its maintainer scripts
# directly. Useful for distros without dpkg/rpm (Arch, Alpine, NixOS, etc.) or
# when running dpkg/rpm is not desired.
#
# Requires: bash, curl or wget, ar (binutils), tar, openssl, systemd (for the
# daemon postinstall step). zstd is needed if the .deb uses zstd compression.

set -euo pipefail

CHANNEL_BASE_URL="https://downloads.oneleet.com/agent/linux"

usage() {
  cat <<EOF
Usage: sudo $0 [--arch amd64|arm64] [--keep]

Downloads the latest Oneleet agent .deb, extracts it, and runs the
package's maintainer scripts so the agent is installed on any
Linux distribution.

Options:
  --arch ARCH   Target architecture (amd64 or arm64). Auto-detected if omitted.
  --keep        Keep the staging directory after install (for debugging).
  -h, --help    Show this help.
EOF
}

arch=""
keep=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --arch) arch="${2:-}"; shift 2 ;;
    --keep) keep=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "$arch" ]]; then
  case "$(uname -m)" in
    x86_64|amd64) arch="amd64" ;;
    aarch64|arm64) arch="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m). Pass --arch amd64|arm64." >&2; exit 1 ;;
  esac
fi

case "$arch" in
  amd64) yml_url="$CHANNEL_BASE_URL/beta-linux.yml" ;;
  arm64) yml_url="$CHANNEL_BASE_URL/beta-linux-arm64.yml" ;;
  *) echo "Unsupported architecture: $arch (expected amd64 or arm64)" >&2; exit 1 ;;
esac

if [[ $EUID -ne 0 ]]; then
  echo "Error: this script must be run as root (try: sudo $0)" >&2
  exit 1
fi

for tool in ar tar awk sed grep openssl base64; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: required tool '$tool' is not installed" >&2
    exit 1
  fi
done

if command -v curl >/dev/null 2>&1; then
  fetcher="curl"
elif command -v wget >/dev/null 2>&1; then
  fetcher="wget"
else
  echo "Error: neither 'curl' nor 'wget' is installed" >&2
  exit 1
fi

# fetch URL OUT [silent]
fetch() {
  local url="$1" out="$2" silent="${3:-0}"
  if [[ "$fetcher" == "curl" ]]; then
    if (( silent )); then
      curl -fsSL --retry 3 -o "$out" "$url"
    else
      curl -fSL --retry 3 --progress-bar -o "$out" "$url"
    fi
  else
    if (( silent )); then
      wget -q --tries=3 -O "$out" "$url"
    else
      wget --tries=3 -O "$out" "$url"
    fi
  fi
}

work_dir=$(mktemp -d -t oneleet-install-XXXXXX)
if (( keep )); then
  echo "Staging directory will be kept: $work_dir"
else
  trap 'rm -rf "$work_dir"' EXIT
fi
cd "$work_dir"

echo "Fetching manifest: $yml_url"
fetch "$yml_url" manifest.yml 1

# Find the .deb entry and the sha512 immediately following it. The yml format
# from electron-builder is stable enough that the sha512 line follows url:
deb_lineno=$(grep -nE '^[[:space:]]*-[[:space:]]*url:.*\.deb[[:space:]]*$' manifest.yml | head -1 | cut -d: -f1)
if [[ -z "${deb_lineno:-}" ]]; then
  echo "Error: could not locate a .deb entry in manifest" >&2
  exit 1
fi

deb_filename=$(sed -n "${deb_lineno}p" manifest.yml \
  | sed -E 's/^[[:space:]]*-[[:space:]]*url:[[:space:]]*//; s/[[:space:]]+$//')
expected_sha512=$(sed -n "$((deb_lineno + 1))p" manifest.yml \
  | sed -E 's/^[[:space:]]*sha512:[[:space:]]*//; s/[[:space:]]+$//')

if [[ -z "$deb_filename" || -z "$expected_sha512" ]]; then
  echo "Error: failed to parse .deb url/sha512 from manifest" >&2
  exit 1
fi

deb_url="$CHANNEL_BASE_URL/$deb_filename"
echo "Downloading: $deb_url"
fetch "$deb_url" package.deb 0

# Manifest sha512 is base64-encoded; compute the same way for comparison.
actual_sha512=$(openssl dgst -sha512 -binary package.deb | base64 | tr -d '\n')

if [[ "$actual_sha512" != "$expected_sha512" ]]; then
  echo "Error: sha512 mismatch on downloaded .deb" >&2
  echo "  expected: $expected_sha512" >&2
  echo "  actual:   $actual_sha512" >&2
  exit 1
fi
echo "Checksum verified."

echo "Extracting package..."
mkdir extracted
( cd extracted && ar x ../package.deb )

extract_tar() {
  local archive="$1" dest="$2"
  case "$archive" in
    *.tar.gz|*.tgz)        tar -xzf "$archive" -C "$dest" ;;
    *.tar.xz)              tar -xJf "$archive" -C "$dest" ;;
    *.tar.bz2)             tar -xjf "$archive" -C "$dest" ;;
    *.tar.zst|*.tar.zstd)
      if ! command -v zstd >/dev/null 2>&1; then
        echo "Error: this .deb uses zstd compression; install 'zstd' and re-run" >&2
        exit 1
      fi
      zstd -dc "$archive" | tar -xf - -C "$dest"
      ;;
    *.tar)                 tar -xf "$archive" -C "$dest" ;;
    *) echo "Error: unknown archive format: $archive" >&2; exit 1 ;;
  esac
}

mkdir control data
shopt -s nullglob
for archive in extracted/control.tar.*; do
  extract_tar "$archive" control
done
for archive in extracted/data.tar.*; do
  extract_tar "$archive" data
done
shopt -u nullglob

if ! find data -mindepth 1 -print -quit | grep -q .; then
  echo "Error: package data archive was empty" >&2
  exit 1
fi

echo "Placing files into /..."
cp -a data/. /

# On SELinux distros (Fedora/RHEL/CentOS/Rocky), `cp -a` carries the staging
# directory's context onto the installed files, so /opt/Oneleet/oneleet-daemon
# ends up labelled user_tmp_t and systemd refuses to exec it (status=203/EXEC).
# Re-label the install tree to the file_contexts default so systemd can run it.
if command -v restorecon >/dev/null 2>&1; then
  restorecon -RF /opt/Oneleet 2>/dev/null || true
fi

run_hook() {
  local hook="$1"; shift
  local script="control/$hook"
  if [[ -f "$script" ]]; then
    chmod +x "$script"
    echo "Running $hook..."
    DPKG_MAINTSCRIPT_NAME="$hook" \
    DPKG_MAINTSCRIPT_PACKAGE="oneleet-agent" \
      "$script" "$@"
  fi
}

# Mimic dpkg's install sequence: preinst install, unpack, postinst configure.
run_hook preinst install
run_hook postinst configure

check_shared_libs() {
  local agent_bin="/opt/Oneleet/oneleet-agent"
  if [[ ! -x "$agent_bin" ]]; then
    return 0
  fi
  if ! command -v ldd >/dev/null 2>&1; then
    echo "Note: 'ldd' not available; skipping shared library check." >&2
    return 0
  fi

  local missing
  missing=$(ldd "$agent_bin" 2>/dev/null | awk '/=> not found/ {print $1}' | sort -u)
  if [[ -z "$missing" ]]; then
    return 0
  fi

  echo >&2
  echo "Warning: the following shared libraries required by oneleet-agent are missing:" >&2
  while IFS= read -r lib; do
    echo "  - $lib" >&2
  done <<< "$missing"
  echo >&2
  echo "The GUI agent will not launch until these are installed. Typical providers:" >&2
  echo "  Debian/Ubuntu: libnss3 libgtk-3-0 libnotify4 libasound2 libcups2 libxss1 libatk1.0-0 libatspi2.0-0" >&2
  echo "  Fedora/RHEL:   nss gtk3 libnotify alsa-lib cups-libs libXScrnSaver atk at-spi2-atk" >&2
  echo "  Arch:          nss gtk3 libnotify alsa-lib libcups libxss atk at-spi2-atk" >&2
  echo "  Gentoo:        dev-libs/nss x11-libs/gtk+:3 x11-libs/libnotify media-libs/alsa-lib net-print/cups x11-libs/libXScrnSaver dev-libs/atk app-accessibility/at-spi2-core" >&2
  return 1
}

echo
if check_shared_libs; then
  echo "Oneleet agent installed successfully."
else
  echo "Oneleet agent installed, but missing shared libraries above must be resolved before launching the GUI."
fi
