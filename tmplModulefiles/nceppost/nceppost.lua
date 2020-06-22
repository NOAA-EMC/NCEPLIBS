help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgVersion)

setenv("nceppost_ROOT", base)
setenv("nceppost_VERSION", pkgVersion)
setenv("NCEPPOST_INC", pathJoin(base,"include"))
setenv("NCEPPOST_LIB", pathJoin(base,"lib/libnceppost.a"))
setenv("POST_INC", pathJoin(base,"include"))
setenv("POST_LIB", pathJoin(base,"lib/libnceppost.a"))
