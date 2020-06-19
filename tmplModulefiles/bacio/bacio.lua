help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("bacio_ROOT", pathJoin(base,"bacio"))
setenv("bacio_VERSION", pkgVersion)
setenv("BACIO_INC4", pathJoin(base,"bacio/include_4"))
setenv("BACIO_INC8", pathJoin(base,"bacio/include_8"))
setenv("BACIO_LIB4", pathJoin(base,"bacio/lib/libbacio_4.a"))
setenv("BACIO_LIB8", pathJoin(base,"bacio/lib/libbacio_8.a"))
