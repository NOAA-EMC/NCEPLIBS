help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("wrf_io_ROOT", base)
setenv("wrf_io_VERSION", pkgVersion)
setenv("WRF_IO_INC", pathJoin(base,"include"))
setenv("WRF_IO_LIB", pathJoin(base,"lib/libwrf_io.a"))
