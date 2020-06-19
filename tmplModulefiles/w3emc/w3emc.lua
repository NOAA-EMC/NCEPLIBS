help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("w3emc_ROOT", pathJoin(base,"w3emc"))
setenv("w3emc_VERSION", pkgVersion)
setenv("W3EMC_INC4", pathJoin(base,"w3emc/include_4"))
setenv("W3EMC_INC8", pathJoin(base,"w3emc/include_8"))
setenv("W3EMC_INCd", pathJoin(base,"w3emc/include_d"))
setenv("W3EMC_LIB4", pathJoin(base,"w3emc/lib/libw3emc_4.a"))
setenv("W3EMC_LIB8", pathJoin(base,"w3emc/lib/libw3emc_8.a"))
setenv("W3EMC_LIBd", pathJoin(base,"w3emc/lib/libw3emc_d.a"))
