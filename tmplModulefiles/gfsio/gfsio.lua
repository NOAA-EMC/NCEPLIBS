help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("gfsio_ROOT", pathJoin(base,"gfsio"))
setenv("gfsio_VERSION", pkgVersion)
setenv("GFSIO_INC",  pathJoin(base,"gfsio/include"))
setenv("GFSIO_LIB",  pathJoin(base,"gfsio/lib/libgfsio.a"))
