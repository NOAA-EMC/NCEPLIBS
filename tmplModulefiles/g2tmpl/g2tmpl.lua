help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("g2tmpl_ROOT", pathJoin(base,"g2tmpl"))
setenv("g2tmpl_VERSION", pkgVersion)
setenv("G2TMPL_INC", pathJoin(base,"g2tmpl/include"))
setenv("G2TMPL_LIB", pathJoin(base,"g2tmpl/lib/libg2tmpl.a"))
