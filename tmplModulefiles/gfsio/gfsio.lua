help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgVersion)

setenv("gfsio_ROOT", base)
setenv("gfsio_VERSION", pkgVersion)
setenv("GFSIO_INC",  pathJoin(base,"include"))
setenv("GFSIO_LIB",  pathJoin(base,"lib/libgfsio.a"))
