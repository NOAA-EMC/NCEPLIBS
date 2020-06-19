help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("landsfcutil_ROOT", pathJoin(base,"landsfcutil"))
setenv("landsfcutil_VERSION", pkgVersion)
setenv("LANDSFCUTIL_INC4", pathJoin(base,"landsfcutil/include_4"))
setenv("LANDSFCUTIL_INCd", pathJoin(base,"landsfcutil/include_d"))
setenv("LANDSFCUTIL_LIB4", pathJoin(base,"landsfcutil/lib/liblandsfcutil_4.a"))
setenv("LANDSFCUTIL_LIBd", pathJoin(base,"landsfcutil/lib/liblandsfcutil_d.a"))
