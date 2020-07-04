help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("wrfio_ROOT", base)
setenv("wrfio_VERSION", pkgVersion)
setenv("WRFIO_INC", pathJoin(base,"include"))
setenv("WRFIO_LIB", pathJoin(base,"lib/libwrfio.a"))
