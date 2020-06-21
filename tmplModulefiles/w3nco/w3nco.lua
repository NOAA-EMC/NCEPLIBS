help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgVersion)

setenv("w3nco_ROOT", base)
setenv("w3nco_VERSION", pkgVersion)
setenv("W3NCO_INC4", pathJoin(base,"include_4"))
setenv("W3NCO_INC8", pathJoin(base,"include_8"))
setenv("W3NCO_INCd", pathJoin(base,"include_d"))
setenv("W3NCO_LIB4", pathJoin(base,"lib/libw3nco_4.a"))
setenv("W3NCO_LIB8", pathJoin(base,"lib/libw3nco_8.a"))
setenv("W3NCO_LIBd", pathJoin(base,"lib/libw3nco_d.a"))
