help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgName .. '-' .. pkgVersion)

setenv("nemsio_ROOT", base)
setenv("nemsio_VERSION", pkgVersion)
setenv("NEMSIO_INC", pathJoin(base,"include"))
setenv("NEMSIO_LIB", pathJoin(base,"lib/libnemsio.a"))
prepend_path("PATH", pathJoin(base,"bin"))
