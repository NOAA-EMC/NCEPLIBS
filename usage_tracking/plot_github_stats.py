#!/usr/bin/env python3
import sys
import json
import matplotlib.pyplot as plt
import numpy as np
import re

def create_plot(json_path, output_png):
    with open(json_path) as f:
        data = json.load(f)

    repos = list(data.keys())

    if not repos:
        print("No repositories found in data.")
        return

    # Extract sorted list of day intervals (e.g., 30, 60, etc.)
    sample_keys = data[repos[0]].keys()
    day_numbers = sorted(int(re.search(r'\d+', key).group()) for key in sample_keys if key.startswith("commits_"))

    # Build a dict of {days: [commit_counts per repo]}
    commits_by_day = {d: [] for d in day_numbers}
    for repo in repos:
        for d in day_numbers:
            commits_by_day[d].append(data[repo].get(f"commits_{d}", 0))

    x = np.arange(len(repos))

    fig, ax = plt.subplots(figsize=(12, 6))

    for d in day_numbers:
        ax.plot(x, commits_by_day[d], marker='o', label=f"Last {d} days")

    ax.set_xticks(x)
    ax.set_xticklabels(repos, rotation=45, ha='right')
    ax.set_ylabel('Number of commits')
    ax.set_title('GitHub commit activity by repository')
    ax.legend()

    plt.tight_layout()
    plt.savefig(output_png)
    plt.close()

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python plot_github_stats.py github_stats.json github_stats.png")
        sys.exit(1)
    create_plot(sys.argv[1], sys.argv[2])
