#!/usr/bin/env python3
"""Recolor Orchis-solidDark from Orchis-kde b2a96919 to match GTK Dracula.

Usage: build-kvantum-dracula.py /path/to/Orchis-kde /path/to/output/Kvantum
Upstream: https://github.com/vinceliuice/Orchis-kde (Vince Liuice, GPL-3.0),
based on KvAdapta by Tsu Jan. The installer downloads the source and license.
"""

from pathlib import Path
import argparse
import configparser
import re
import shutil


PALETTE = {
    "#0057ae": "#8be9fd", "#1a73e8": "#a679ec", "#3daee6": "#bd93f9",
    "#4285f4": "#bd93f9", "#b74aff": "#bd93f9", "#e040fb": "#ff79c6",
    "#81c995": "#50fa7b", "#f04a50": "#ff5555",
    "#0f0f0f": "#0f1015", "#181818": "#1c1e26", "#1a1a1a": "#1f2029",
    "#1e1e1e": "#1f2029", "#212121": "#1c1e26", "#242424": "#242632",
    "#262626": "#242632", "#26272a": "#242632", "#282828": "#1f2029",
    "#292929": "#242632", "#2c2c2c": "#242632", "#2e2e2e": "#1f2029",
    "#323232": "#343746", "#333333": "#343746", "#343031": "#343746",
    "#36383e": "#3c3f51", "#3a3a3a": "#3c3f51", "#3a474e": "#474b61",
    "#424242": "#44475a", "#474747": "#474b61", "#4d4d4d": "#343746",
    "#535353": "#626784", "#5a5a5a": "#626784", "#5a616e": "#626784",
    "#646464": "#757a99", "#666666": "#757a99", "#696969": "#757a99",
    "#787878": "#8f94ad", "#989898": "#9397af", "#acb1bc": "#b5b8c9",
    "#b6b6b6": "#b5b8c9", "#c1c1c1": "#c4c7d4", "#d1d1d1": "#d9dae3",
    "#dfdfdf": "#f8f8f2", "#eaeaea": "#f8f8f2", "#efefef": "#f8f8f2",
    "#ffffff": "#f8f8f2",
}


def write_kde_palette(source, destination):
    """KDE widgets and symbolic icons also read KColorScheme, outside QStyle."""
    scheme = configparser.ConfigParser(interpolation=None)
    scheme.optionxform = str
    scheme.read(source / "color-schemes/OrchisDark.colors")

    def rgb(color):
        return ",".join(str(int(color[i:i + 2], 16)) for i in (1, 3, 5))

    backgrounds = {
        "Button": ("#343746", "#3c3f51"),
        "Complementary": ("#1f2029", "#242632"),
        "Header": ("#1c1e26", "#242632"),
        "Header][Inactive": ("#1c1e26", "#242632"),
        "Selection": ("#bd93f9", "#bd93f9"),
        "Tooltip": ("#1c1e26", "#1f2029"),
        "View": ("#242632", "#1f2029"),
        "Window": ("#1c1e26", "#242632"),
    }
    for name, (background, alternate) in backgrounds.items():
        colors = {
            "BackgroundNormal": background, "BackgroundAlternate": alternate,
            "DecorationFocus": "#bd93f9", "DecorationHover": "#a679ec",
            "ForegroundNormal": "#f8f8f2", "ForegroundInactive": "#9397af",
            "ForegroundActive": "#bd93f9", "ForegroundLink": "#8be9fd",
            "ForegroundVisited": "#ff79c6", "ForegroundNegative": "#ff5555",
            "ForegroundNeutral": "#f1fa8c", "ForegroundPositive": "#50fa7b",
        }
        if name == "Selection":
            colors.update({key: "#1c1e26" for key in colors if key.startswith("Foreground")})
        scheme[f"Colors:{name}"] = {key: rgb(value) for key, value in colors.items()}
    scheme["ColorEffects:Disabled"].update({
        "IntensityEffect": "0", "ColorEffect": "0", "ContrastAmount": "0.45",
    })
    scheme["ColorEffects:Inactive"]["Enable"] = "false"
    scheme["General"].update({"ColorScheme": "OrchisDracula", "Name": "Material Dracula"})
    scheme["KDE"]["contrast"] = "0"
    scheme["WM"] = {key: rgb(value) for key, value in {
        "activeBackground": "#1c1e26", "activeBlend": "#1c1e26",
        "activeForeground": "#f8f8f2", "inactiveBackground": "#1c1e26",
        "inactiveBlend": "#1c1e26", "inactiveForeground": "#9397af",
    }.items()}
    with (destination / "OrchisDracula.colors").open("w") as output:
        scheme.write(output, space_around_delimiters=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    source, destination = args.source, args.destination
    destination.mkdir(parents=True, exist_ok=True)
    for extension in ("svg", "kvconfig"):
        text = (source / "Kvantum/Orchis-solid"
                / f"Orchis-solidDark.{extension}").read_text()
        text = re.sub(r"#[0-9a-fA-F]{6}\b", lambda m: PALETTE.get(m[0].lower(), m[0]), text)
        if extension == "kvconfig":
            text = text.replace("comment=An uncomplicated theme inspired by the Materia GTK theme",
                                "comment=Material Dracula, based on Orchis-solidDark")
            for key in ("translucent_windows", "blurring", "popup_blurring", "blur_translucent"):
                text = text.replace(f"{key}=true", f"{key}=false")
            text = text.replace("layout_spacing=3", "layout_spacing=6")
            text = text.replace("layout_margin=3", "layout_margin=8")
            text = text.replace("highlight.text.color=white", "highlight.text.color=#1c1e26")
            for section in ("ItemView", "MenuItem"):
                pattern = rf"(\[{section}\]\n)(.*?)(?=^\[|\Z)"
                text = re.sub(pattern, lambda m: m[1] + re.sub(
                    r"(text\.(?:focus|press|toggle)\.color)=.*",
                    r"\1=#1c1e26", m[2]), text, flags=re.M | re.S)
        (destination / f"OrchisDracula.{extension}").write_text(text)
    shutil.copyfile(source / "LICENSE", destination / "LICENSE")
    write_kde_palette(source, destination)


if __name__ == "__main__":
    main()
