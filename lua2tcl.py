#!/usr/bin/env python

import os
import re
import sys

"""
This script converts the NCEPLIBS lua modules into tcl modules for dinosaur systems
that do not know how to handle lua modules in the 21st century. This script is not
a general tool to convert lua modulefiles to tcl modules. It only works for the
auto-generated lua modulefiles of the NCEPLIBS umbrella build.
"""

basedir=sys.argv[1]

TCL_TEMPLATE="""#%Module######################################################################

proc ModulesHelp {{ }} {{
  puts "Set environment variables for {name}-{version}"
}}

# Make sure another version of the same package is not already loaded
conflict {name}

# Set environment variables
set base {base}

setenv {name}_ROOT    "${{base}}"
setenv {name}_VERSION "{version}"
{setenv_commands}
"""

for root,dirs,files in os.walk(basedir):
    for file in files:
        if file.endswith(".lua"):
            version = file.rstrip(".lua")
            name = os.path.split(root)[1]
            infile = os.path.join(root,file)
            outfile = os.path.join(root,file.rstrip(".lua"))
            print("Converting {} to {} ...".format(infile, outfile))
            with open(infile) as f:
                lua_in = f.readlines()
            prefix = None
            base = None
            setenv_commands = ''
            for line_in in lua_in:
                line = line_in.rstrip('\n')
                if line.startswith("local prefix = \""):
                    prefix = line.lstrip("local prefix = \"").rstrip("\"")
                    base = os.path.join(prefix,"{name}-{version}".format(name=name, version=version))
                elif line.startswith("setenv"):
                    if line == 'setenv("{name}_ROOT", base)'.format(name=name):
                        continue
                    elif line == 'setenv("{name}_VERSION", pkgVersion)'.format(name=name):
                        continue
                    else:
                        # Match lines like the following
                        # setenv("BACIO_LIB8", pathJoin(base,"lib/libbacio_8.a"))
                        match = re.match('^setenv\("(\w+)",\s+pathJoin\(base,"(.+)"\)\)$', line)
                        if not match:
                            raise Exception("Error while parsing line '{}' in {}".format(line, infile))
                        envvar = match.group(1)
                        value  = match.group(2)
                        path = '${base}' + '/' + value
                        setenv_commands += 'setenv {envvar} "{path}"\n'.format(envvar=envvar, path=path)
                        continue
            tcl_out = TCL_TEMPLATE.format(name=name, version=version, base=base, setenv_commands=setenv_commands)
            if os.path.isfile(outfile):
                os.remove(outfile)
            with open(outfile, "w") as f:
                f.write(tcl_out)
