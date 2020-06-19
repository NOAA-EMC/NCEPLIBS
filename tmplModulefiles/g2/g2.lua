help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("g2_ROOT", pathJoin(base,"g2"))
setenv("g2_VERSION", pkgVersion)
setenv("g2_INC4", pathJoin(base,"g2/include_4"))
setenv("G2_INCd", pathJoin(base,"g2/include_d"))
setenv("G2_LIB4", pathJoin(base,"g2/lib/libg2_4.a"))
setenv("G2_LIBd", pathJoin(base,"g2/lib/libg2_d.a"))
