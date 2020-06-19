help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("ip_ROOT", pathJoin(base,"ip"))
setenv("ip_VERSION", pkgVersion)
setenv("IP_INC4", pathJoin(base,"ip/include_4"))
setenv("IP_INC8", pathJoin(base,"ip/include_8"))
setenv("IP_INCd", pathJoin(base,"ip/include_d"))
setenv("IP_LIB4", pathJoin(base,"ip/lib/libip_4.a"))
setenv("IP_LIB8", pathJoin(base,"ip/lib/libip_8.a"))
setenv("IP_LIBd", pathJoin(base,"ip/lib/libip_d.a"))
