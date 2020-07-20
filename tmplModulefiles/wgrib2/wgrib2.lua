help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("wgrib2_ROOT", base)
setenv("wgrib2_VERSION", pkgVersion)
setenv("WGRIB2_INC", pathJoin(base,"include"))
setenv("WGRIB_LIB", pathJoin(base,"lib/libwgrib2.a"))
setenv("WGRIB2_LIBAPI", pathJoin(base,"lib/libwgrib2_api.a"))

prepend_path("PATH", pathJoin(base,"bin"))