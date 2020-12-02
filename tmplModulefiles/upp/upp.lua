help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("upp_ROOT", base)
setenv("upp_VERSION", pkgVersion)
setenv("NCEPPOST_INC", pathJoin(base,"include"))
setenv("NCEPPOST_LIB", pathJoin(base,"lib/libupp.a"))
setenv("POST_INC", pathJoin(base,"include"))
setenv("POST_LIB", pathJoin(base,"lib/libupp.a"))
setenv("UPP_INC", pathJoin(base,"include"))
setenv("UPP_LIB", pathJoin(base,"lib/libupp.a"))
