#!/usr/bin/env bash
# Download and install Material Dracula for GTK and Qt as the desktop user.
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
revision=a4c48a425e63808345e824495964bd9c2f462e04
checksum=14b875d260b27c449a05c08829ac775c586dcd07e41d3da370fff8a1b4407f5c
theme_name=Orchis-Purple-Dark-Dracula
build_id="$revision-purple-dark-solid-round6px"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/material-dracula"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
theme_dir="$data_dir/themes"
gtk_config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0"
backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/material-dracula/backups"
archive="$cache_dir/orchis-$revision.tar.gz"
source_dir="$cache_dir/Orchis-theme-$revision"
stamp="$theme_dir/$theme_name/.material-dracula-revision"

for dependency in curl tar sha256sum sassc python3; do
  if ! command -v "$dependency" >/dev/null 2>&1; then
    printf 'Missing dependency: %s\nInstall the theme dependencies with playbooks/07-setup-themes.yml first.\n' "$dependency" >&2
    exit 1
  fi
done

mkdir -p "$cache_dir" "$theme_dir" "$gtk_config"

if [[ ! -f "$stamp" ]] || [[ "$(cat "$stamp")" != "$build_id" ]]; then
  if [[ ! -f "$archive" ]]; then
    curl --fail --location --retry 3 \
      "https://codeload.github.com/vinceliuice/Orchis-theme/tar.gz/$revision" \
      --output "$archive.part"
    mv "$archive.part" "$archive"
  fi
  printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check --status
  tar --extract --gzip --file "$archive" --directory "$cache_dir" --no-same-owner
  bash "$source_dir/install.sh" --dest "$theme_dir" \
    --theme purple --color dark --size standard --tweaks dracula solid --round 6px

  for stylesheet in gtk-3.0/gtk.css gtk-3.0/gtk-dark.css gtk-4.0/gtk.css gtk-4.0/gtk-dark.css; do
    test -s "$theme_dir/$theme_name/$stylesheet"
  done
  printf '%s\n' "$build_id" > "$stamp"
fi

kvantum_revision=b2a96919eee40264e79db402b915f926436100ad
kvantum_checksum=915e1c53589f33a403ac7a72746d657f39ea3529aa80af8ab9ef4e7d2e79cdc5
kvantum_dir="$theme_dir/OrchisDracula/Kvantum"
kvantum_archive="$cache_dir/orchis-kde-$kvantum_revision.tar.gz"
kvantum_source="$cache_dir/Orchis-kde-$kvantum_revision"
kvantum_build_id="$kvantum_revision-$(sha256sum "$script_dir/build-kvantum-dracula.py" | cut -d ' ' -f 1)"
kvantum_stamp="$kvantum_dir/.material-dracula-revision"
kvantum_rebuild=false
for item in OrchisDracula.svg OrchisDracula.kvconfig OrchisDracula.colors LICENSE; do
  if [[ ! -s "$kvantum_dir/$item" ]]; then
    kvantum_rebuild=true
  fi
done

if [[ "$kvantum_rebuild" == true ]] || [[ ! -f "$kvantum_stamp" ]] || [[ "$(cat "$kvantum_stamp")" != "$kvantum_build_id" ]]; then
  if [[ ! -f "$kvantum_archive" ]]; then
    curl --fail --location --retry 3 \
      "https://codeload.github.com/vinceliuice/Orchis-kde/tar.gz/$kvantum_revision" \
      --output "$kvantum_archive.part"
    mv "$kvantum_archive.part" "$kvantum_archive"
  fi
  printf '%s  %s\n' "$kvantum_checksum" "$kvantum_archive" | sha256sum --check --status
  tar --extract --gzip --file "$kvantum_archive" --directory "$cache_dir" --no-same-owner
  python3 "$script_dir/build-kvantum-dracula.py" "$kvantum_source" "$kvantum_dir"
  printf '%s\n' "$kvantum_build_id" > "$kvantum_stamp"
  printf 'Installing Material Dracula for Kvantum.\n'
fi

mkdir -p "$data_dir/color-schemes"
if ! cmp -s "$kvantum_dir/OrchisDracula.colors" "$data_dir/color-schemes/OrchisDracula.colors"; then
  install -m 0644 "$kvantum_dir/OrchisDracula.colors" "$data_dir/color-schemes/OrchisDracula.colors"
  printf 'Updating KDE color scheme.\n'
fi

if ! grep -Fxq 'IconTheme=Papirus-Dark' "$theme_dir/$theme_name/index.theme"; then
  sed -i 's/^IconTheme=.*/IconTheme=Papirus-Dark/' "$theme_dir/$theme_name/index.theme"
  printf 'Updating GTK icon theme to Papirus-Dark.\n'
fi
for item in gtk.css gtk-dark.css assets; do
  target="$theme_dir/$theme_name/gtk-4.0/$item"
  link="$gtk_config/$item"
  if [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$target" ]]; then
    continue
  fi
  if [[ -e "$link" || -L "$link" ]]; then
    mkdir -p "$backup_dir"
    mv "$link" "$backup_dir/$item.$(date +%Y%m%d-%H%M%S-%N)"
  fi
  ln -s "$target" "$link"
done

printf 'Installed Material Dracula (GTK 3, GTK 4, libadwaita and Kvantum).\n'
