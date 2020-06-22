help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgName .. '-' .. pkgVersion)

setenv("landsfcutil_ROOT", base)
setenv("landsfcutil_VERSION", pkgVersion)
setenv("LANDSFCUTIL_INC4", pathJoin(base,"include_4"))
setenv("LANDSFCUTIL_INCd", pathJoin(base,"include_d"))
setenv("LANDSFCUTIL_LIB4", pathJoin(base,"lib/liblandsfcutil_4.a"))
setenv("LANDSFCUTIL_LIBd", pathJoin(base,"lib/liblandsfcutil_d.a"))
