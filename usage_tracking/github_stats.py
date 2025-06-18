#!/usr/bin/env python3
import os
import sys
import yaml
import json
import subprocess
import tempfile
from datetime import datetime, timedelta

def count_recent_commits(repo_url, days):
    since = datetime.now() - timedelta(days=days)
    since_str = since.strftime('%Y-%m-%d')

    with tempfile.TemporaryDirectory() as tmpdir:
        try:
            subprocess.run([
                "git", "clone", repo_url, tmpdir
            ], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

            result = subprocess.run([
                "git", "-C", tmpdir, "log", f"--since={since_str}", "--pretty=oneline"
            ], capture_output=True, text=True, check=True)

            return len(result.stdout.strip().splitlines())
        except Exception as e:
            print(f"Failed to count commits for {repo_url}: {e}", file=sys.stderr)
            return 0

def generate_commit_data(config_path, json_output_path):
    with open(config_path) as f:
        cfg = yaml.safe_load(f)

    days_list = [30, 60, 90, 180]
    repo_data = {}
    for repo in cfg['repos']:
        repo_url = f"https://github.com/{repo}.git"

        repo_data[repo] = {}
        for days in days_list:
            repo_data[repo][f"commits_{days}"] = count_recent_commits(repo_url, days=days)

    print("## GitHub commit activity by repository\n")
    print("| Repo | 30 Days | 60 Days | 90 Days | 180 Days |")
    print("|---------|---------|---------|---------|-----------|")
    for repo, data in repo_data.items():
        print(f"| `{repo}` | {data['commits_30']} | {data['commits_60']} | {data['commits_90']} | {data['commits_180']} |")

    with open(json_output_path, "w") as f:
        json.dump(repo_data, f, indent=2)

if __name__ == '__main__':
    generate_commit_data(sys.argv[1], sys.argv[2])
