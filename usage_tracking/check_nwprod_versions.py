#!/usr/bin/env python3
import requests
import re
import sys
import yaml
from bs4 import BeautifulSoup

def list_version_dirs(base_url):
    resp = requests.get(base_url)
    soup = BeautifulSoup(resp.text, 'html.parser')
    return [
        a['href'].strip('/')
        for a in soup.find_all('a')
        if a['href'].endswith('/') and not a['href'].startswith('?') and '.v' in a['href']
    ]

def fetch_versions(base_url, directory, files, libs):
    results = {}
    for file in files:
        try:
            url = f"{base_url}{directory}/{file}"
            print("Getting URL:", url, file=sys.stderr)
            text = requests.get(url).text
            for lib in libs:
                match = re.search(rf'(^|\s+){lib}_ver[\'"]?\s*=["\']?(?P<version>\d[\w\.]+)', text.lower())
                if match:
                    results[lib] = match.group("version")
        except Exception as e:
            print(f"Warning: Failed to fetch {url} ({e})", file=sys.stderr)
            continue
    return results

def main(config_path):
    with open(config_path) as f:
        cfg = yaml.safe_load(f)

    base_url = cfg['nwprod_base_url']
    files = ['build.ver', 'run.ver']
    libs = cfg['libraries']
    deprecated = cfg['deprecated']

    if 'nwprod_subdirs' in cfg:
        dirs = cfg['nwprod_subdirs']
    else:
        dirs = [d + "/versions/" for d in list_version_dirs(base_url)]

    print("## Library usage in operational code (NCO/WCOSS)\n")
    print("The following table is based on each ops model's versions/{build,run}.ver files.\n")

    # Header row
    colorized_libs = [f'<span style="color:red"><code>{l}</code></span>' if l in deprecated else f"`{l}`" for l in libs]
    header = "| prod code | " + " | ".join(f"{lib}" for lib in colorized_libs) + " |"
    separator = "|-------------|" + "|".join(["---"] * len(libs)) + "|"
    print(header)
    print(separator)

    lib_counts = {lib: 0 for lib in libs}
    total_rows = 0

    for dir in sorted(dirs):
        print(f"Processing: {dir}", file=sys.stderr)
        usage = fetch_versions(base_url, dir, files, libs)

        # Skip completely empty rows
        if not usage:
            row = [f"`{dir.rstrip('/versions/')}`"] + ["❌"] * len(libs)
        else:
            row = [f"`{dir.rstrip('/versions/')}`"]
            for lib in libs:
                if lib in usage:
                    row.append(usage[lib])
                    lib_counts[lib] += 1
                else:
                    row.append("❌")
        print("| " + " | ".join(row) + " |")
        total_rows += 1

    # TOTAL row
    total_row = ["**TOTAL**"]
    for lib in libs:
        total_row.append(str(lib_counts[lib]))
    print("| " + " | ".join(total_row) + " |")

    print(header.replace("prod code", ""))

if __name__ == '__main__':
    main(sys.argv[1])
