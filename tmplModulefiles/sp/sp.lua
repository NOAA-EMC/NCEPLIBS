help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("sp_ROOT", pathJoin(base,"sp"))
setenv("sp_VERSION", pkgVersion)
setenv("SP_INC4", pathJoin(base,"sp/include_4"))
setenv("SP_INC8", pathJoin(base,"sp/include_8"))
setenv("SP_INCd", pathJoin(base,"sp/include_d"))
setenv("SP_LIB4", pathJoin(base,"sp/lib/libsp_4.a"))
setenv("SP_LIB8", pathJoin(base,"sp/lib/libsp_8.a"))
setenv("SP_LIBd", pathJoin(base,"sp/lib/libsp_d.a"))
