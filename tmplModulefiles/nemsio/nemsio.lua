help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("nemsio_ROOT", pathJoin(base,"nemsio"))
setenv("nemsio_VERSION", pkgVersion)
setenv("NEMSIO_INC", pathJoin(base,"nemsio/include"))
setenv("NEMSIO_LIB", pathJoin(base,"nemsio/lib/libnemsio.a"))
