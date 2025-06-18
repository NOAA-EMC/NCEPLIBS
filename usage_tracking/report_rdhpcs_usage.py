#!/usr/bin/env python3

import sys
import yaml

def tabulate_module_loads(config_path):
    with open(config_path) as f:
        cfg = yaml.safe_load(f)

    libs = cfg["libraries"]

    for site in cfg["rdhpcs_module_loads"].keys():
        data_path = cfg["rdhpcs_module_loads"][site]["data_path"]
        with open(data_path) as f:
            data = [l.split()[::-1] for l in f.readlines()]
        nceplibs_data = [l for l in data if l[0].split("/")[0] in libs]

        date_range = cfg["rdhpcs_module_loads"][site]["date_range"]

        print()
        print(f"## {site} module loads")
        print(f"The following is from module load tracking on {site} (RDHPCS) login nodes for **{date_range}**.")
        print()
        print(f"| Package | Loads |")
        print("|---------|---------|")
        for lib in nceplibs_data[::-1]:
            print("|", lib[0], "|", lib[1], "|")


if __name__ == '__main__':
    tabulate_module_loads(sys.argv[1])
