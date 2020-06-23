help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("w3emc_ROOT", base)
setenv("w3emc_VERSION", pkgVersion)
setenv("W3EMC_INC4", pathJoin(base,"include_4"))
setenv("W3EMC_INC8", pathJoin(base,"include_8"))
setenv("W3EMC_INCd", pathJoin(base,"include_d"))
setenv("W3EMC_LIB4", pathJoin(base,"lib/libw3emc_4.a"))
setenv("W3EMC_LIB8", pathJoin(base,"lib/libw3emc_8.a"))
setenv("W3EMC_LIBd", pathJoin(base,"lib/libw3emc_d.a"))
