#!/usr/bin/env python3
import requests
import re
import sys
import yaml
from urllib.parse import urlparse
from os.path import basename

def fetch_text(url):
    r = requests.get(url)
    r.raise_for_status()
    return r.text

def main(config_path):
    with open(config_path) as f:
        cfg = yaml.safe_load(f)

    libs = cfg['libraries']
    deprecated = cfg['deprecated']
    modulefiles = cfg['modulefiles']

    results = {}
    print("## Library usage in EMC models\n")
    print("The following table is based on module file contents, using version information when available.\n")

    # Header
    colorized_libs = [f'<span style="color:red"><code>{l}</code></span>' if l in deprecated else f"`{l}`" for l in libs]
    header = "| Model | " + " | ".join(f"{lib}" for lib in colorized_libs) + " |"
    separator = "|--------|" + "|".join(["---"] * len(libs)) + "|"
    print(header)
    print(separator)

    lib_counts = {lib: 0 for lib in libs}

    for model, url in modulefiles.items():
        print(f"Fetching modulefile for: {model}", file=sys.stderr)
        text = fetch_text(url)
        lines = text.splitlines()
        uncommented = [line for line in lines if not line.strip().startswith('--')]
        content = '\n'.join(uncommented)

        modfile_name = basename(urlparse(url).path)
        label = f"{model} ({modfile_name})"

        row = [label]
        results[model] = {}

        for lib in libs:
            # Match any line containing the lib name in brackets or quotes and extract a version number if present
            version_match = None
            lib_found = False

            for line in uncommented:
                # *.ver format: export <lib>_ver=<version>
                m = re.search(rf'^\s*export\s+{re.escape(lib)}_ver\s*=\s*v?(\S+)', line)
                if m:
                    lib_found = True
                    version_match = m
                    break
                # Lua/modulefile format: lib name in brackets or quotes
                if re.search(rf'[\[\"\']{lib}[\]\"\'/]', line):
                    lib_found = True
                    version_match = re.search(r'[\"\'/]((?:\d+\.)+\d+)[\"\']', line)
                    if version_match:
                        break

            if version_match:
                version = version_match.group(1)
                row.append(version)
                lib_counts[lib] += 1
                results[model][lib] = version
            elif lib_found:
                row.append("✅")
                lib_counts[lib] += 1
                results[model][lib] = True
            else:
                row.append("❌")
                results[model][lib] = False

        print("| " + " | ".join(row) + " |")

    # TOTAL row
    total_row = ["**TOTAL**"] + [str(lib_counts[lib]) for lib in libs]
    print("| " + " | ".join(total_row) + " |")

if __name__ == '__main__':
    main(sys.argv[1])
