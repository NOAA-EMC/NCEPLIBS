help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("bacio_ROOT", base)
setenv("bacio_VERSION", pkgVersion)
setenv("BACIO_INC4", pathJoin(base,"include_4"))
setenv("BACIO_INC8", pathJoin(base,"include_8"))
setenv("BACIO_LIB4", pathJoin(base,"lib/libbacio_4.a"))
setenv("BACIO_LIB8", pathJoin(base,"lib/libbacio_8.a"))
