#!/usr/bin/env python3
import json

# apparently ClassiCube's default.png is just a 0-255 map of the CP437 Extended ASCII table, so we can map this to minecraft's accented.png and nonlatin_european.png

CLASSICUBE_JSON = "classicube.json"
MINECRAFT_JSON = "default.json"

MC_TARGETS = {
    "minecraft:font/accented.png",
    "minecraft:font/nonlatin_european.png",
}

def load_json(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)

def get_bitmap_providers(data):
    return [
        p for p in data["providers"]
        if p.get("type") == "bitmap"
    ]

def build_glyph_table(provider):
    # char -> (index, x, y)
    table = {}

    i = 0
    chars = provider["chars"]

    for y, row in enumerate(chars):
        for x, ch in enumerate(row):
            table[ch] = (i, x, y)
            i += 1

    return table

def find_provider(providers, filename):
    for p in providers:
        if p["file"] == filename:
            return p
    return None

def main():
    cc_data = load_json(CLASSICUBE_JSON)
    mc_data = load_json(MINECRAFT_JSON)

    cc_provider = find_provider(
        get_bitmap_providers(cc_data),
        "classicube:font/default.png"
    )

    if not cc_provider:
        raise RuntimeError("classicube.json not found")

    mc_providers = [
        p for p in get_bitmap_providers(mc_data)
        if p["file"] in MC_TARGETS
    ]

    cc_table = build_glyph_table(cc_provider)

    mc_tables = {
        p["file"]: build_glyph_table(p)
        for p in mc_providers
    }
    
    for ch, (cc_index, cc_x, cc_y) in cc_table.items():
        codepoint = ord(ch)
        for name, mc_table in mc_tables.items():
            if ch in mc_table:
                mc_index, mc_x, mc_y = mc_table[ch]
                print(
                    f"U+{codepoint:04X} '{ch}' | "
                    f"classicube:font/default.png "
                    f"{cc_index}-{cc_x},{cc_y}.png"
                    f" -> {name} "
                    f"{mc_index}-{mc_x},{mc_y}.png"
                )

if __name__ == "__main__":
    main()
