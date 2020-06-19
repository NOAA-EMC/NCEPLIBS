help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("nceppost_ROOT", pathJoin(base,"nceppost"))
setenv("nceppost_VERSION", pkgVersion)
setenv("NCEPPOST_INC", pathJoin(base,"nceppost/include"))
setenv("NCEPPOST_LIB", pathJoin(base,"nceppost/lib/libnceppost.a"))
setenv("POST_INC", pathJoin(base,"nceppost/include"))
setenv("POST_LIB", pathJoin(base,"nceppost/lib/libnceppost.a"))
