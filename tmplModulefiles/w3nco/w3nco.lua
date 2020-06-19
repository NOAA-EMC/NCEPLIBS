help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("w3nco_ROOT", pathJoin(base,"w3nco"))
setenv("w3nco_VERSION", pkgVersion)
setenv("W3NCO_INC4", pathJoin(base,"w3nco/include_4"))
setenv("W3NCO_INC8", pathJoin(base,"w3nco/include_8"))
setenv("W3NCO_INCd", pathJoin(base,"w3nco/include_d"))
setenv("W3NCO_LIB4", pathJoin(base,"w3nco/lib/libw3nco_4.a"))
setenv("W3NCO_LIB8", pathJoin(base,"w3nco/lib/libw3nco_8.a"))
setenv("W3NCO_LIBd", pathJoin(base,"w3nco/lib/libw3nco_d.a"))
